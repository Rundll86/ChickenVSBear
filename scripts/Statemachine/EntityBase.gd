extends CharacterBody2D
class_name EntityBase # 这是个抽象类

@export var fields: Dictionary = {
	FieldStore.Entity.MAX_HEALTH: 100,
	FieldStore.Entity.DAMAGE_MULTIPILER: 1,
	FieldStore.Entity.MOVEMENT_SPEED: 1,
	FieldStore.Entity.ATTACK_SPEED: 1,
	FieldStore.Entity.CRIT_RATE: 0.05, # 0.05 = 5%
	FieldStore.Entity.CRIT_DAMAGE: 2 # 2 = 200%
} # 存一下词条
@export var isBoss: bool = false
@export var cooldownUnit: float = 100 # 100毫秒每次攻击

@onready var animatree: AnimationTree = $"%animatree"
@onready var texture: AnimatedSprite2D = $"%texture"
@onready var hurtbox: Area2D = $"%hurtbox"

var health: float = 0

var lastDirection: int = 1
var lastAttack: int = 0

func _ready():
	health = fields.get(FieldStore.Entity.MAX_HEALTH)
func _process(_delta):
	health = clamp(health, 0, fields.get(FieldStore.Entity.MAX_HEALTH))
	animatree.set("parameters/blend_position", lerpf(animatree.get("parameters/blend_position"), lastDirection, 0.1))
func _physics_process(_delta: float) -> void:
	velocity = Vector2.ZERO
	ai()
	move_and_slide()

# 通用方法
func move(direction: Vector2):
	velocity = direction.normalized() * fields.get(FieldStore.Entity.MOVEMENT_SPEED) * 200 * abs(animatree.get("parameters/blend_position"))
	var currentDirection = sign(direction.x)
	if currentDirection != 0:
		lastDirection = currentDirection
func takeDamage(bullet: BulletBase):
	health -= bullet.damage
	if health <= 0:
		die()
func isCooldowned():
	return Time.get_ticks_msec() - lastAttack >= cooldownUnit
func startCooldown():
	var state = isCooldowned()
	if state:
		lastAttack = Time.get_ticks_msec()
	return state
func tryAttack(type: int):
	if startCooldown():
		attack(type)
func findWeaponAnchor(weaponName: String):
	var anchor = $"%weapons".get_node(weaponName)
	if anchor is Node2D:
		return (anchor.position + texture.position) * Vector2(animatree.get("parameters/blend_position"), 1) + position
	else:
		return Vector2.ZERO

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

static func generate(
	entity: PackedScene,
	spawnPosition: Vector2,
	spawnRotation: float,
	isMob: bool = true,
	addtoWorld: bool = true
):
	var instance: EntityBase = entity.instance()
	instance.position = spawnPosition
	instance.rotation = spawnRotation
	if isMob:
		instance.add_to_group("mobs")
	if addtoWorld:
		WorldTool.rootNode.add_child(instance)
	return instance
