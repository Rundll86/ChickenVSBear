extends Area2D
class_name BulletBase

@export var speed: float = 10.0
@export var damage: float = 10.0
@export var penerate: float = 0.0
@export var lifeDistance: float = -1 # -1表示无限距离
@export var lifeTime: float = -1 # -1表示无限时间
@export var indisDamage: bool = false # 是否无差别伤害（不区分敌我）
@export var canDamageSelf: bool = false # 是否可以伤害发射者
@export var autoSpawnAnimation: bool = false
@export var autoLoopAnimation: bool = false
@export var autoDestroyAnimation: bool = false
@export var autoDestroyOnHitMap: bool = true
@export var freeAfterSpawn: bool = false
@export var knockback: float = 0 # 击退力，物理引擎单位
@export var recoil: float = 0 # 后坐力，物理引擎单位

@onready var animator: AnimationPlayer = $"%animator"
@onready var hitbox: CollisionShape2D = $"%hitbox"
@onready var texture: AnimatedSprite2D = $"%texture"

var launcher: EntityBase = null
var spawnInWhen: float = 0
var spawnInWhere: Vector2 = Vector2.ZERO
var destroying: bool = false
var isChildSplit: bool = false
var isChildRefract: bool = false

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
			tryDestroy()
	if autoLoopAnimation:
		animator.play("loop")
	body_entered.connect(
		func(body):
			if body.is_in_group("map"):
				if autoDestroyOnHitMap:
					tryDestroy(true)
	)
func _process(_delta: float) -> void:
	if destroying: return
	if lifeTime > 0:
		if WorldManager.getTime() - spawnInWhen >= lifeTime:
			tryDestroy()
	if lifeDistance > 0:
		if position.distance_to(spawnInWhere) >= lifeDistance:
			tryDestroy()
func _physics_process(_delta: float) -> void:
	if destroying: return
	if is_instance_valid(launcher) and (launcher.isPlayer() or is_instance_valid(launcher.currentFocusedBoss)):
		launcher.position -= Vector2.from_angle(rotation) * recoil
		PresetAIs.trace(
			self,
			EntityTool.findClosetEntity(position, get_tree(),
			!launcher.isPlayer(),
			launcher.isPlayer(),
			[launcher]
			).position,
			launcher.fields.get(FieldStore.Entity.BULLET_TRACE) / 10
		)
		ai()
	else:
		tryDestroy()

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
		tryDestroy()
func forward(direction: Vector2):
	position += direction.normalized() * speed * GameRule.bulletSpeedMultiplier
func fullPenerate():
	return penerate + launcher.fields.get(FieldStore.Entity.PENERATE) + GameRule.penerateRateInfluenceByLuckValue * launcher.fields[FieldStore.Entity.LUCK_VALUE]
func timeLived():
	return WorldManager.getTime() - spawnInWhen
func dotLoop():
	if await applyDot():
		await dotLoop()
func tryDestroy(becauseMap: bool = false):
	if destroying: return
	destroying = true
	trySplit()
	tryRefract()
	await destroy(becauseMap)
	if autoDestroyAnimation:
		animator.play("destroy")
		await animator.animation_finished
	queue_free()
func trySplit():
	if is_instance_valid(launcher) and !isChildSplit:
		var launcherSplit = launcher.fields.get(FieldStore.Entity.BULLET_SPLIT)
		for i in range(MathTool.shrimpRate(launcherSplit)):
			split(i, launcherSplit, launcherSplit - floor(launcherSplit))
func tryRefract():
	if is_instance_valid(launcher) and !isChildRefract:
		var value = launcher.fields.get(FieldStore.Entity.BULLET_REFRACTION)
		var entity = EntityTool.findClosetEntity(position, get_tree(), !launcher.isPlayer(), launcher.isPlayer())
		for i in range(MathTool.shrimpRate(value)):
			refract(entity, i, value, value - floor(value))

# 抽象方法
func ai():
	pass
func destroy(_beacuseMap: bool):
	pass
func spawn():
	pass
func applyDot():
	pass
func succeedToHit(_dmg: float):
	pass
func register():
	pass
func split(_index: int, _total: int, _lastBullet: float):
	pass
func refract(_entity: EntityBase, _index: int, _total: int, _lastBullet: float):
	pass

static func generate(
		bullet: PackedScene,
	 	launchBy: EntityBase,
	  	spawnPosition: Vector2,
	  	spawnRotation: float,
		asChildSplit: bool = false,
		asChildRefract: bool = false,
	   	addToWorld: bool = true
	):
	var extraCount = launchBy.fields.get(FieldStore.Entity.EXTRA_BULLET_COUNT)
	var count = 1 + MathTool.shrimpRate(extraCount)
	var instances = []
	for i in range(count):
		var instance: BulletBase = bullet.instantiate()
		instance.isChildSplit = asChildSplit
		instance.isChildRefract = asChildRefract
		instance.launcher = launchBy
		instance.position = spawnPosition
		instance.rotation = spawnRotation + deg_to_rad(randf_range(-launchBy.fields.get(FieldStore.Entity.OFFSET_SHOOT), launchBy.fields.get(FieldStore.Entity.OFFSET_SHOOT)))
		if addToWorld:
			WorldManager.rootNode.call_deferred("add_child", instance)
		instances.append(instance)
	return instances
