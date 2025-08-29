extends Area2D
class_name BulletBase

@export var speed: float = 10.0
@export var damage: float = 10.0
@export var penerate: float = 0.0
@export var lifeDistance: float = -1 # -1表示无限距离
@export var lifeTime: float = -1 # -1表示无限时间
@export var indisDamage: bool = false # 是否无差别伤害（不区分敌我）
@export var canDamageSelf: bool = false # 是否可以伤害发射者
@export var needEnergy: float = 0.0 # 发射时需要消耗的能量
@export var autoSpawnAnimation: bool = false
@export var autoLoopAnimation: bool = false
@export var freeAfterSpawn: bool = false
@export var knockback: float = 0 # 击退力，物理引擎单位
@export var recoil: float = 0 # 后坐力，物理引擎单位

@onready var animator: AnimationPlayer = $"%animator"
@onready var hitbox: CollisionShape2D = $"%hitbox"
@onready var texture: AnimatedSprite2D = $"%texture"

var launcher: EntityBase = null
var spawnInWhen: float = 0
var spawnInWhere: Vector2 = Vector2.ZERO

func _ready():
	register()
	area_entered.connect(hit)
	spawnInWhen = WorldManager.getTime()
	spawnInWhere = position
	spawn()
	dotLoop()
	if autoSpawnAnimation:
		animator.play("spawn")
		await animator.animation_finished
		if freeAfterSpawn:
			destroy()
	if autoLoopAnimation:
		animator.play("loop")
func _process(_delta: float) -> void:
	if lifeTime > 0:
		if WorldManager.getTime() - spawnInWhen >= lifeTime:
			destroy()
	if lifeDistance > 0:
		if position.distance_to(spawnInWhere) >= lifeDistance:
			destroy()
func _physics_process(_delta: float) -> void:
	if is_instance_valid(launcher) and (launcher.isPlayer() or is_instance_valid(launcher.currentFocusedBoss)):
		launcher.position -= Vector2.from_angle(rotation) * recoil
		ai()

func hit(target: Node):
	var entity: EntityBase = EntityTool.fromHurtbox(target)
	if !entity || !launcher: return
	if !canDamageSelf && entity == launcher: return
	if !indisDamage && !GameRule.allowFriendlyFire:
		if entity.isPlayer() == launcher.isPlayer(): return
	var damages = entity.takeDamage(self, MathTool.rate(launcher.fields.get(FieldStore.Entity.CRIT_RATE) + GameRule.critRateInfluenceByLuckValue * launcher.fields[FieldStore.Entity.LUCK_VALUE]))
	succeedToHit(damages)
	if MathTool.rate(fullPenerate()):
		penerate -= entity.fields[FieldStore.Entity.PENARATION_RESISTANCE]
	else:
		destroy()
func forward(direction: Vector2):
	position += direction.normalized() * speed * GameRule.bulletSpeedMultiplier
func fullPenerate():
	return penerate + launcher.fields.get(FieldStore.Entity.PENERATE) + GameRule.penerateRateInfluenceByLuckValue * launcher.fields[FieldStore.Entity.LUCK_VALUE]
func timeLived():
	return WorldManager.getTime() - spawnInWhen
func dotLoop():
	if await applyDot():
		await dotLoop()

func ai():
	pass
func destroy():
	queue_free()
func spawn():
	pass
func applyDot():
	pass
func succeedToHit(_dmg: float):
	pass
func register():
	pass

static func generate(
		bullet: PackedScene,
	 	launchBy: EntityBase,
	  	spawnPosition: Vector2,
	  	spawnRotation: float,
	   	addToWorld: bool = true
	):
	var extraCount = launchBy.fields.get(FieldStore.Entity.EXTRA_BULLET_COUNT)
	var count = 1 + floor(extraCount) + int(MathTool.rate(extraCount - floor(extraCount)))
	var instances = []
	for i in range(count):
		var instance: BulletBase = bullet.instantiate()
		if launchBy.useEnergy(instance.needEnergy):
			instance.launcher = launchBy
			instance.position = spawnPosition
			instance.rotation = spawnRotation + deg_to_rad(randf_range(-launchBy.fields.get(FieldStore.Entity.OFFSET_SHOOT), launchBy.fields.get(FieldStore.Entity.OFFSET_SHOOT)))
			if addToWorld:
				WorldManager.rootNode.add_child(instance)
			instances.append(instance)
	return len(instances)
