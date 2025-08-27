extends CharacterBody2D
class_name EntityBase # 这是个抽象类

signal hit(damage: float, bullet: BulletBase, crit: bool)
signal healed(amount: float)
signal healthChanged(health: float)

signal energyChanged(energy: float)

var fields = {
	FieldStore.Entity.MAX_HEALTH: 100,
	FieldStore.Entity.DAMAGE_MULTIPILER: 1,
	FieldStore.Entity.MOVEMENT_SPEED: 1,
	FieldStore.Entity.ATTACK_SPEED: 1,
	FieldStore.Entity.CRIT_RATE: 0.05,
	FieldStore.Entity.CRIT_DAMAGE: 1,
	FieldStore.Entity.PENERATE: 0,
	FieldStore.Entity.OFFSET_SHOOT: 3,
	FieldStore.Entity.HEAL_ABILITY: 1,
	FieldStore.Entity.EXTRA_APPLE_MAX: 0,
	FieldStore.Entity.ENERGY_MULTIPILER: 1,
	FieldStore.Entity.PENARATION_RESISTANCE: 0,
	FieldStore.Entity.PRICE_REDUCTION: 0,
	FieldStore.Entity.EXTRA_BULLET_COUNT: 0,
	FieldStore.Entity.DROP_APPLE_RATE: 0,
	FieldStore.Entity.FEED_COUNT_SHOW: 3,
	FieldStore.Entity.FEED_COUNT_CAN_MADE: 1,
	FieldStore.Entity.MAX_ENERGY: 200,
}
var inventory = {
	ItemStore.ItemType.BASEBALL: 100,
	ItemStore.ItemType.BASKETBALL: 100,
	ItemStore.ItemType.APPLE: 10,
}
var inventoryMax = {
	ItemStore.ItemType.BASEBALL: INF, # 无限
	ItemStore.ItemType.BASKETBALL: INF,
	ItemStore.ItemType.APPLE: 20, # 最多20个苹果
}

@export var cooldownUnit: float = 100 # 100毫秒每次攻击
@export var isBoss: bool = false
@export var displayName: String = "未知实体"
@export var sprintMultiplier: float = 4
@export var drops: Array[ItemStore.ItemType] = []
@export var dropCounts: Array[Vector2] = []
@export var appleCount: Vector2i = Vector2(0, 1) # 死亡后掉落的苹果数量

@onready var animatree: AnimationTree = $"%animatree"
@onready var texture: AnimatedSprite2D = $"%texture"
@onready var hurtbox: Area2D = $"%hurtbox"
@onready var statebar: EntityStateBar = $"%statebar"
@onready var sounds: Node2D = $"%sounds"
@onready var hurtAnimator: AnimationPlayer = $"%hurtAnimator"
@onready var damageAnchor: Node2D = $"%damageAnchor"

var health: float = 0
@export var energy: float = 0
var sprinting: bool = false

var lastDirection: int = 1
var lastAttack: int = 0
var currentFocusedBoss: EntityBase = null

func _ready():
	health = fields.get(FieldStore.Entity.MAX_HEALTH)
	statebar.visible = !isBoss
	if isPlayer():
		UIState.player = self
		hurtbox.body_entered.connect(
			func(body):
				if body is ItemDropped:
					inventory[body.item] += body.stackCount
					body.queue_free()
		)
		energyChanged.connect(
			func(newEnergy):
				UIState.energyPercent.maxValue = fields.get(FieldStore.Entity.MAX_ENERGY)
				UIState.energyPercent.setCurrent(newEnergy)
		)
	else:
		currentFocusedBoss = get_tree().get_nodes_in_group("players")[0]
	healthChanged.emit(health)
	energyChanged.emit(energy)
func _process(_delta):
	health = clamp(health, 0, fields.get(FieldStore.Entity.MAX_HEALTH))
	energy = clamp(energy, 0, fields.get(FieldStore.Entity.MAX_ENERGY))
	for i in inventory:
		inventory[i] = clamp(inventory[i], 0, inventoryMax[i])
func _physics_process(_delta: float) -> void:
	animatree.set("parameters/blend_position", lerpf(animatree.get("parameters/blend_position"), lastDirection, 0.2))
	if sprinting:
		velocity *= 0.9
		if velocity.length() <= 100:
			sprinting = false
	else:
		velocity = Vector2.ZERO
		if isPlayer() or is_instance_valid(currentFocusedBoss):
			ai()
	move_and_slide()
	storeEnergy(0.01)

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
	var baseDamage: float = bullet.fields.get(FieldStore.Bullet.DAMAGE) * bullet.launcher.fields.get(FieldStore.Entity.DAMAGE_MULTIPILER) * randf_range(1 - GameRule.damageOffset, 1 + GameRule.damageOffset)
	var damage = baseDamage + baseDamage * int(crit) * fields.get(FieldStore.Entity.CRIT_DAMAGE)
	if sprinting:
		playSound("miss")
		storeEnergy(damage * 1.25)
		damage = 0
	else:
		playSound("hurt")
		bullet.launcher.storeEnergy(damage * 0.05)
		storeEnergy(damage * -0.1)
	hit.emit(damage, bullet, crit)
	healthChanged.emit(health)
	health -= damage
	DamageLabel.create(damage, crit, damageAnchor.global_position + MathTool.randv2_range(GameRule.damageLabelSpawnOffset))
	if isBoss and bullet.launcher.isPlayer():
		bullet.launcher.setBoss(self)
	if health <= 0:
		if isBoss:
			bullet.launcher.storeEnergy(energy)
			bullet.launcher.setBoss(null)
		tryDie(bullet)
func storeEnergy(value: float):
	energy += value * fields.get(FieldStore.Entity.ENERGY_MULTIPILER)
	energyChanged.emit(energy)
func useEnergy(value: float):
	var state = energy >= value
	if state:
		energy -= value
		energyChanged.emit(energy)
	return state
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
		if attack(type):
			playSound("attack" + str(type))
	return state
func trySprint():
	playSound("sprint")
	sprint()
	sprinting = true
func tryDie(by: BulletBase):
	for drop in range(min(len(drops), len(dropCounts))):
		var item = drops[drop]
		var count = ceil(randf_range(dropCounts[drop].x, dropCounts[drop].y))
		for i in range(count):
			ItemDropped.generate(item, count, position + MathTool.randv2_range(GameRule.itemDroppedSpawnOffset))
	if MathTool.rate(GameRule.appleDropRate + by.launcher.fields.get(FieldStore.Entity.DROP_APPLE_RATE)) or isBoss:
		for i in randi_range(appleCount.x, appleCount.y):
			ItemDropped.generate(ItemStore.ItemType.APPLE, 1, position + MathTool.randv2_range(GameRule.itemDroppedSpawnOffset))
	die()
func tryHeal(count: float):
	if inventory[ItemStore.ItemType.APPLE] > 0 and health < fields.get(FieldStore.Entity.MAX_HEALTH):
		inventory[ItemStore.ItemType.APPLE] -= 1
		playSound("heal")
		healed.emit(heal(count * fields.get(FieldStore.Entity.HEAL_ABILITY)))
		healthChanged.emit(health)
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
func heal(count: float):
	health += count
	return count

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
static func mobCount():
	return len(WorldManager.tree.get_nodes_in_group("mobs"))
