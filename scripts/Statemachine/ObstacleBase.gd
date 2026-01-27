extends StaticBody2D
class_name ObstacleBase

signal healthChanged(newHealth: float)

@export var healthMax: float = 100
@export var penerateResistance: float = 0
@export var blockPlayer: bool = false
@export var blockEnemy: bool = false

@onready var statebar: ObstacleStateBar = $%statebar
@onready var texture: AnimatedSprite2D = $%texture
@onready var hitbox: CollisionShape2D = $%hitbox
var health: float = 0
var launcher: EntityBase = null

func _ready():
	health = healthMax
	if blockPlayer:
		collision_layer |= EntityBase.Layers.PLAYER
		collision_mask |= EntityBase.Layers.PLAYER
	if blockEnemy:
		collision_layer |= EntityBase.Layers.ENEMY
		collision_mask |= EntityBase.Layers.ENEMY
	healthChanged.connect(
		func(newHealth):
			statebar.healthBar.maxValue = healthMax
			statebar.healthBar.setCurrent(newHealth)
	)
func _process(_delta):
	statebar.global_rotation = 0
	statebar.applyText()

func initHealth(maxHealth: float):
	healthMax = maxHealth
	health = healthMax
	statebar.forceSync()
	statebar.applyText()
func takeDamage(damage: float):
	health -= damage
	healthChanged.emit(health)
	if health <= 0:
		tryDie()
func tryDie():
	die()
	queue_free()

func die():
	pass

static func generate(
	obstacle: PackedScene,
	spawnPosition: Vector2,
	spawnRotation: float = 0,
	itsLauncher: EntityBase = null,
	addToWorld: bool = true
) -> ObstacleBase:
	var instance: ObstacleBase = obstacle.instantiate()
	instance.position = spawnPosition
	instance.rotation = spawnRotation
	instance.launcher = itsLauncher
	if addToWorld:
		WorldManager.rootNode.spawn(instance)
	return instance
