extends Area2D
class_name BulletBase

@export var fields = {
	FieldStore.Bullet.SPEED: 10,
	FieldStore.Bullet.DAMAGE: 10,
	FieldStore.Bullet.PENERATE: 0
}
@export var lifeDistance: float = -1 # -1表示无限距离
@export var lifeTime: float = -1 # -1表示无限时间

var launcher: EntityBase = null
var spawnInWhen: float = 0
var spawnInWhere: Vector2 = Vector2.ZERO

func _ready():
	area_entered.connect(hit)
	spawnInWhen = Time.get_ticks_msec()
	spawnInWhere = position
func _process(_delta: float) -> void:
	if lifeTime > 0:
		if Time.get_ticks_msec() - spawnInWhen >= lifeTime:
			destroy()
	if lifeDistance > 0:
		if position.distance_to(spawnInWhere) >= lifeDistance:
			destroy()
func _physics_process(_delta: float) -> void:
	if is_instance_valid(launcher) and (launcher.isPlayer() or is_instance_valid(launcher.currentFocusedBoss)):
		ai()

func hit(target: Node):
	var entity: EntityBase = EntityTool.fromHurtbox(target)
	if !entity || !launcher: return
	if entity == launcher: return
	if !GameRule.allowFriendlyFire:
		if entity.isPlayer() == launcher.isPlayer(): return
	entity.takeDamage(self, MathTool.rate(launcher.fields.get(FieldStore.Entity.CRIT_RATE)))
	if !MathTool.rate(fullPenerate()):
		destroy()
func forward(direction: Vector2):
	position += direction.normalized() * fields.get(FieldStore.Bullet.SPEED) * GameRule.bulletSpeedMultiplier
func fullPenerate():
	return fields.get(FieldStore.Bullet.PENERATE) * (1 + launcher.fields.get(FieldStore.Entity.PENERATE))

func ai():
	pass
func destroy():
	queue_free()

static func generate(
		bullet: PackedScene,
	 	launchBy: EntityBase,
	  	spawnPosition: Vector2,
	  	spawnRotation: float,
	   	addToWorld: bool = true
	):
	var instance: BulletBase = bullet.instantiate()
	instance.launcher = launchBy
	instance.position = spawnPosition
	instance.rotation = spawnRotation + deg_to_rad(randf_range(-launchBy.fields.get(FieldStore.Entity.OFFSET_SHOOT), launchBy.fields.get(FieldStore.Entity.OFFSET_SHOOT)))
	if addToWorld:
		WorldManager.rootNode.add_child(instance)
	return instance
