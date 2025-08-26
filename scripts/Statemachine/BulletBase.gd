extends Area2D
class_name BulletBase

@export var speed: float = 1
@export var damage: float = 10

var launcher: EntityBase = null

func _ready():
	area_entered.connect(hit)

func hit(target: Node):
	var entity: EntityBase = EntityTool.fromHurtbox(target)
	if !entity || !launcher: return
	if entity == launcher: return
	if GameRule.allowFriendlyFire:
		if entity.isPlayer() == launcher.isPlayer(): return
	entity.takeDamage(self)

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
	instance.rotation = spawnRotation
	if addToWorld:
		WorldTool.rootNode.add_child(instance)
	return instance
