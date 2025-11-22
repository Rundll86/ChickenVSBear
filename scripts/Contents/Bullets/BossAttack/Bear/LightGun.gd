extends BulletBase

@export var allColor: GradientTexture1D = null
@export var length: float = 1000

@onready var track: ShaderStage = $"%track"
@onready var sword: Sprite2D = $"%sword"
@onready var points: GPUParticles2D = $"%points"

var myColor: Color
func register():
	speed = 1
	baseDamage = 1
	penerate = 1
func spawn():
	myColor = allColor.gradient.sample(randf())
	track.material = track.material.duplicate()
	points.process_material = points.process_material.duplicate()
	setColor(myColor)
	track.size.y = length
	TickTool.modifyAnimationKey(animator, "spawn", "sword:position:x", Animation.TrackType.TYPE_BEZIER, 2.5, length / -2)
	TickTool.modifyAnimationKey(animator, "spawn", "sword:position:x", Animation.TrackType.TYPE_BEZIER, 3, length / 2)
	TickTool.modifyAnimationKey(animator, "spawn", "%hitbox:position:x", Animation.TrackType.TYPE_BEZIER, 2.5, length / -2)
	TickTool.modifyAnimationKey(animator, "spawn", "%hitbox:position:x", Animation.TrackType.TYPE_BEZIER, 3, length / 2)
	await TickTool.millseconds(2500)
	points.emitting = true
func setColor(color: Color):
	color.v *= 2
	var result = Color(color)
	result.a = 0
	track.material.set_shader_parameter("laser_color", result)
	sword.modulate = color
	points.process_material.color = color
