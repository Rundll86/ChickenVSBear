extends BulletBase

@export var allColor: GradientTexture1D = null

@onready var track: Node2D = $"%track"
@onready var sword: Sprite2D = $"%sword"
@onready var points: GPUParticles2D = $"%points"

var myColor: Color
func register():
	speed = 1
	damage = 5
	penerate = 1
func spawn():
	myColor = allColor.gradient.sample(randf())
	track.material = track.material.duplicate()
	points.process_material = points.process_material.duplicate()
	setColor(myColor)
func setColor(color: Color):
	track.material.set_shader_parameter("color", color)
	sword.modulate = color
	points.process_material.color = color
