extends BulletBase

@export var allColor: GradientTexture1D = null

@onready var superlight: Node2D = $"%superlight"
@onready var trail: GPUParticles2D = $"%trail"

var myColor: Color
var tracer: EntityBase = null
var forwardTime: float = 500
var forwarded: bool = false

func register():
	speed = 1
	damage = 5
	penerate = 1
func spawn():
	myColor = allColor.gradient.sample(randf())
	superlight.material = superlight.material.duplicate()
	trail.process_material = trail.process_material.duplicate()
	setColor(myColor)


func ai():
	superlight.global_rotation_degrees = 90
	PresetBulletAI.forward(self, rotation)
	if timeLived() <= forwardTime:
		speed = 10 * ((forwardTime - timeLived()) / forwardTime)
	elif forwarded:
		if timeLived() < forwardTime + 2000:
			speed = clamp((timeLived() - forwardTime) / 75, 0, 30)
			if is_instance_valid(tracer):
				PresetBulletAI.trace(self, tracer.position, 0.03)
	else:
		forwarded = true


func setColor(color: Color):
	texture.self_modulate = color
	var mat: ParticleProcessMaterial = trail.process_material
	mat.color = color
	superlight.material.set_shader_parameter("color", color)
