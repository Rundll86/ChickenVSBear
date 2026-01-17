extends BulletBase

@export var allColor: GradientTexture1D = null

@onready var superlight: Node2D = $"%superlight"
@onready var trail: GPUParticles2D = $"%trail"

var myColor: Color
var tracer: EntityBase = null
var traceTime: float = 2000
var forwardTime: float = 500
var forwarded: bool = false

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
			if is_instance_valid(tracer) and timeLived() <= traceTime + forwardTime:
				PresetBulletAI.trace(self, tracer.position, 0.1 * (traceTime - (timeLived() - forwardTime)) / traceTime)
	else:
		forwarded = true


func setColor(color: Color):
	texture.self_modulate = color
	var mat: ParticleProcessMaterial = trail.process_material
	mat.color = color
	superlight.material.set_shader_parameter("color", color)
