extends BulletBase

@onready var trail: GPUParticles2D = $"%trail"
@onready var track: Node2D = $"%track"

var readyTime: float = 1000

func spawn():
	trail.emitting = false
func ai():
	if timeLived() < readyTime:
		rotation = launcher.position.angle_to_point(launcher.currentFocusedBoss.position)
	else:
		PresetBulletAI.forward(self, rotation)
		speed += 1
		trail.emitting = true
		track.visible = false
