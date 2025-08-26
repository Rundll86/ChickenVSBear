extends CharacterBody2D
class_name EntityBase # 这是个抽象类

var fields = {
	FieldStore.Entity.MAX_HEALTH: 100,
	FieldStore.Entity.DAMAGE_MULTIPILER: 1,
	FieldStore.Entity.MOVEMENT_SPEED: 1,
	FieldStore.Entity.ATTACK_SPEED: 1,
	FieldStore.Entity.CRIT_RATE: 0.05,
	FieldStore.Entity.CRIT_DAMAGE: 1,
	FieldStore.Entity.PENERATE: 0,
}

@export var cooldownUnit: float = 100 # 100毫秒每次攻击
@export var isBoss: bool = false
@export var displayName: String = "未知实体"
@export var sprintMultiplier: float = 7

@onready var animatree: AnimationTree = $"%animatree"
@onready var texture: AnimatedSprite2D = $"%texture"
@onready var hurtbox: Area2D = $"%hurtbox"
@onready var statebar: EntityStateBar = $"%statebar"
@onready var sounds: Node2D = $"%sounds"
@onready var hurtAnimator: AnimationPlayer = $"%hurtAnimator"

var health: float = 0

var lastDirection: int = 1
var lastAttack: int = 0
var currentFocusedBoss: EntityBase = null
var sprinting: bool = false

func _ready():
	health = fields.get(FieldStore.Entity.MAX_HEALTH)
	statebar.visible = !isBoss
	if !isPlayer():
		currentFocusedBoss = get_tree().get_nodes_in_group("players")[0]
func _process(_delta):
	health = clamp(health, 0, fields.get(FieldStore.Entity.MAX_HEALTH))
	animatree.set("parameters/blend_position", lerpf(animatree.get("parameters/blend_position"), lastDirection, 0.1))
func _physics_process(_delta: float) -> void:
	if sprinting:
		velocity *= 0.9
		if velocity.length() <= 100:
			sprinting = false
	else:
		velocity = Vector2.ZERO
		if isPlayer() or is_instance_valid(currentFocusedBoss):
			ai()
	move_and_slide()

# 通用方法
func displace(direction: Vector2, isSprinting: bool = false):
	return (direction if isSprinting else direction.normalized()) * fields.get(FieldStore.Entity.MOVEMENT_SPEED) * 400 * abs(animatree.get("parameters/blend_position"))
func move(direction: Vector2, isSprinting: bool = false):
	velocity = displace(direction, isSprinting)
	var currentDirection = sign(direction.x)
	if currentDirection != 0:
		lastDirection = currentDirection
func takeDamage(bullet: BulletBase, crit: bool):
	hurtAnimator.play("hurt")
	var baseDamage: float = bullet.fields.get(FieldStore.Bullet.DAMAGE) * randf_range(1 - GameRule.damageOffset, 1 + GameRule.damageOffset)
	var damage = baseDamage + baseDamage * int(crit) * fields.get(FieldStore.Entity.CRIT_DAMAGE)
	if sprinting:
		playSound("miss")
		damage = 0
	else:
		playSound("hurt")
	health -= damage
	DamageLabel.create(damage, crit, $"%damageAnchor".global_position + MathTool.randv2_range(GameRule.damageLabelSpawnOffset))
	if isBoss:
		bullet.launcher.setBoss(self)
	if health <= 0:
		if isBoss:
			bullet.launcher.setBoss(null)
		die()
func isCooldowned():
	return Time.get_ticks_msec() - lastAttack >= cooldownUnit / fields.get(FieldStore.Entity.ATTACK_SPEED)
func startCooldown():
	var state = isCooldowned()
	if state:
		lastAttack = Time.get_ticks_msec()
	return state
func tryAttack(type: int):
	var state = startCooldown()
	if state:
		playSound("attack" + str(type))
		attack(type)
	return state
func trySprint():
	playSound("sprint")
	sprint()
	sprinting = true
func findWeaponAnchor(weaponName: String):
	var anchor = $"%weapons".get_node(weaponName)
	if anchor is Node2D:
		return anchor.global_position
	else:
		return Vector2.ZERO
func setBoss(boss: EntityBase):
	currentFocusedBoss = boss
	if isPlayer():
		UIState.bossbar.entity = boss
func playSound(type: String):
	var body = sounds.get_node_or_null(type)
	if body is AudioStreamPlayer2D:
		var cloned = body.duplicate() as AudioStreamPlayer2D
		add_child(cloned)
		cloned.play()
		await cloned.finished
		cloned.queue_free()

# 关于分组
func isPlayer():
	return is_in_group("players")

# 抽象方法
func ai():
	pass
func attack(_type: int):
	pass
func die():
	queue_free()
func sprint():
	pass

static func generate(
	entity: PackedScene,
	spawnPosition: Vector2,
	isMob: bool = true,
	spawnAsBoss: bool = false,
	addToWorld: bool = true
):
	var instance: EntityBase = entity.instantiate()
	instance.position = spawnPosition
	instance.isBoss = spawnAsBoss
	if isMob:
		instance.add_to_group("mobs")
	if addToWorld:
		WorldManager.rootNode.add_child(instance)
	return instance
