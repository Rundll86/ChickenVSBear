extends BulletBase

@onready var trail: GPUParticles2D = $"%trail"
@onready var track: Node2D = $"%track"

var readyTime: float = 1000

func register():
	speed = -10
func spawn():
	trail.emitting = false
func ai():
	if timeLived() < readyTime:
		PresetBulletAI.lockLauncher(self, launcher, true)
		rotation = launcher.position.angle_to_point(launcher.currentFocusedBoss.position)
	else:
		PresetBulletAI.forward(self, rotation)
		speed += 2
		trail.emitting = true
		track.visible = false
