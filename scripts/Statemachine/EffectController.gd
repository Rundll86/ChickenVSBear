extends Node2D
class_name EffectController

@export var oneShot: bool = true

@onready var particles: GPUParticles2D = $"%particles"

func _ready():
	particles.emitting = false
	particles.one_shot = oneShot
func shot():
	var cloned = particles.duplicate() as GPUParticles2D
	cloned.emitting = true
	add_child(cloned)
	if oneShot:
		await cloned.finished
		cloned.queue_free()

static func create(scene: PackedScene, spawnPosition: Vector2, parent: Node2D = null) -> EffectController:
	var cloned = scene.instantiate() as EffectController
	cloned.global_position = spawnPosition
	if parent:
		parent.add_child(cloned)
	else:
		WorldManager.rootNode.add_child(cloned)
	return cloned
