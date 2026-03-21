extends Node2D
class_name EffectController

@export var oneShot: bool = true
@export var spawnSound: String = ""
@export var spawnAnimation: String = ""
@export var spawnTexture: String = ""

@onready var particles: GPUParticles2D = $"%particles"
@onready var sounds: Node2D = $"%sounds"
@onready var animator: AnimationPlayer = $"%animator"
@onready var texture: AnimatedSprite2D = $"%texture"

func _ready():
	register()
	particles.emitting = false
	particles.one_shot = oneShot
	var sound = sounds.get_node_or_null(spawnSound)
	if sound and sound.stream:
		sound.play()
	if spawnAnimation:
		animator.play(spawnAnimation)
	if spawnTexture:
		texture.play(spawnTexture)
func shot():
	var childParticle = particles.duplicate() as GPUParticles2D
	childParticle.emitting = true
	add_child(childParticle)
	if oneShot:
		await childParticle.finished
		childParticle.queue_free()
		if spawnSound:
			var sound: AudioStreamPlayer2D = sounds.get_node(spawnSound)
			if sound.playing:
				await sound.finished
		if spawnAnimation:
			if animator.is_playing():
				await animator.animation_finished
		if spawnTexture:
			if texture.is_playing():
				await texture.animation_finished
		queue_free()

func register():
	pass

static func create(scene: PackedScene, spawnPosition: Vector2, parent: Node = null) -> EffectController:
	var cloned = scene.instantiate() as EffectController
	cloned.global_position = spawnPosition
	if parent:
		parent.add_child(cloned)
	else:
		WorldManager.rootNode.add_child(cloned)
	return cloned
