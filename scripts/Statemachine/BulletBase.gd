extends Area2D
class_name BulletBase

@export var displayName: String = "未知子弹"
@export var speed: float = 10.0
@export var baseDamage: float = 10.0
@export var damageMultipliers: Array[float] = [1.0]
@export var usingDamageMultiplier: int = 0
@export var penerate: float = 0.0
@export var penerateDamageReduction: float = 0.0
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
var launcherSummoned: EntityBase = null
var parent: BulletBase = null
var spawnInWhen: float = 0
var spawnInWhere: Vector2 = Vector2.ZERO
var destroying: bool = false
var isChildSplit: bool = false
var isChildRefract: bool = false
var initialSpeed: float = 0
var initialDamage: float = 0
var speedScale: float = 1
var isFirstFrame: bool = true

func _ready():
	initialSpeed = speed
	initialDamage = baseDamage
	if launcher.isSummon():
		launcherSummoned = launcher
		launcher = launcher.myMaster
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
	ai()
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
		var targetEntity = EntityTool.findClosetEntity(position, get_tree(),
		!launcher.isPlayer(),
		launcher.isPlayer(),
		[launcher])
		if is_instance_valid(targetEntity):
			PresetBulletAI.trace(
				self,
				targetEntity.getTrackingAnchor(),
				launcher.fields.get(FieldStore.Entity.BULLET_TRACE) / 10
			)
		if isFirstFrame:
			firstFrame()
			isFirstFrame = false
		ai()
	else:
		tryDestroy()

func setupCuttable(cutSpeed: float):
	area_entered.connect(
		func(body):
			var entity = EntityTool.fromHurtbox(body)
			if entity:
				speedScale = cutSpeed
	)
	area_exited.connect(
		func(body):
			var entity = EntityTool.fromHurtbox(body)
			if entity:
				speedScale = 1
	)
func getDamage():
	return baseDamage * damageMultipliers[usingDamageMultiplier]
func hit(target: Node):
	var entity: EntityBase = EntityTool.fromHurtbox(target)
	if !BulletTool.canDamage(self, entity): return
	var resultDamage = entity.bulletHit(self, MathTool.rate(launcher.fields.get(FieldStore.Entity.CRIT_RATE) + GameRule.critRateInfluenceByLuckValue * launcher.fields[FieldStore.Entity.LUCK_VALUE]))
	succeedToHit(resultDamage, entity)
	if MathTool.rate(fullPenerate()):
		penerate -= entity.fields[FieldStore.Entity.PENARATION_RESISTANCE]
		baseDamage *= 1.0 - penerateDamageReduction
	else:
		tryDestroy()
func forward(direction: Vector2):
	position += direction.normalized() * speed * GameRule.bulletSpeedMultiplier
func fullPenerate():
	return penerate + launcher.fields.get(FieldStore.Entity.PENERATE) + GameRule.penerateRateInfluenceByLuckValue * launcher.fields[FieldStore.Entity.LUCK_VALUE]
func timeLived():
	return WorldManager.getTime() - spawnInWhen
func distanceLived():
	return position.distance_to(spawnInWhere)
func lifeTimePercent():
	return timeLived() / lifeTime
func lifeDistancePercent():
	return distanceLived() / lifeDistance
func dotLoop():
	if await applyDot():
		await TickTool.until(func(): return !UIState.currentPanel)
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
		var value = launcher.fields.get(FieldStore.Entity.BULLET_SPLIT)
		var total = MathTool.shrimpRate(value)
		var last = value - floor(value)
		for i in total:
			var cloned = duplicate() as BulletBase
			cloned.rotation = deg_to_rad(360.0 / total * i)
			split(cloned, i, total, last)
func tryRefract():
	if is_instance_valid(launcher) and !isChildRefract:
		var value = launcher.fields.get(FieldStore.Entity.BULLET_REFRACTION)
		var total = MathTool.shrimpRate(value)
		var last = value - floor(value)
		for i in total:
			var entity = EntityTool.findClosetEntity(position, get_tree(), !launcher.isPlayer(), launcher.isPlayer(), [launcher])
			if is_instance_valid(entity):
				var cloned = duplicate() as BulletBase
				cloned.look_at(entity.position)
				refract(cloned, entity, i, total, last)

# 抽象方法
func firstFrame():
	pass
func ai():
	pass
func destroy(_beacuseMap: bool):
	pass
func spawn():
	pass
func applyDot():
	pass
func succeedToHit(_dmg: float, _entity: EntityBase):
	pass
func register():
	pass
func split(_newBullet: BulletBase, _index: int, _total: int, _lastBullet: float):
	pass
func refract(_newBullet: BulletBase, _entity: EntityBase, _index: int, _total: int, _lastBullet: float):
	pass

static func generate(
		bullet: PackedScene,
	 	launchBy: EntityBase,
	  	spawnPosition: Vector2,
	  	spawnRotation: float,
		asChildSplit: bool = false,
		asChildRefract: bool = false,
	   	addToWorld: bool = true,
		ignoreOffset: bool = false
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
		instance.rotation = spawnRotation + deg_to_rad(launchBy.fields.get(FieldStore.Entity.OFFSET_SHOOT) * randf_range(-1, 1) * int(!ignoreOffset))
		if addToWorld:
			WorldManager.rootNode.call_deferred("add_child", instance)
			instance.add_to_group("bullets")
		instances.append(instance)
	return instances
