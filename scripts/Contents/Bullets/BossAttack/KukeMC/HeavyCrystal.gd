extends BulletBase

@onready var track: Node2D = $"%track"

var readyTime: float = 1000

func register():
	speed = 10
func ai():
	if timeLived() < readyTime:
		PresetBulletAI.lockLauncher(self, launcher, true)
		rotation = launcher.position.angle_to_point(launcher.currentFocusedBoss.getTrackingAnchor())
		hitbox.disabled = true
	else:
		damage = speed / 4
		PresetBulletAI.forward(self, rotation)
		speed *= 1.2
		track.visible = false
		hitbox.disabled = false
