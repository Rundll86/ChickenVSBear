extends BulletBase

@onready var track: Node2D = $"%track"

var readyTime: float = 1000

func register():
	speed = 10
	damage = 30
func ai():
	if timeLived() < readyTime:
		PresetBulletAI.lockLauncher(self, launcher, true)
		rotation = launcher.position.angle_to_point(launcher.currentFocusedBoss.getTrackingAnchor())
		hitbox.disabled = true
	else:
		track.visible = false
		hitbox.disabled = false
		PresetBulletAI.forward(self, rotation)
		speed *= 1.15
