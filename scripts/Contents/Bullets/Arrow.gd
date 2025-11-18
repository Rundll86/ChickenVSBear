extends BulletBase
class_name Arrow

@onready var trail: GPUParticles2D = $%trail

var atk: float = 0
var waitTime: float = 0

func register():
	trail.emitting = false
	hitbox.disabled = true
func ai():
	if timeLived() < waitTime:
		PresetBulletAI.lockLauncher(self, launcher, true)
		rotation = position.angle_to_point(get_global_mouse_position())
		position += Vector2.from_angle(rotation) * 200
		return
	else:
		trail.emitting = true
		hitbox.disabled = false
	speed = (1 - lifeDistancePercent()) * initialSpeed
	damage = speed * atk
	PresetBulletAI.forward(self, rotation)
	if speed < 1:
		tryDestroy()
