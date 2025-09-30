extends BulletBase

@onready var track: Node2D = $"%track"

var readyTime: float = 1000

func register():
	speed = 10
func ai():
	if timeLived() < readyTime:
		PresetBulletAI.lockLauncher(self, launcher, true)
		PresetBulletAI.trace(self, launcher.currentFocusedBoss.getTrackingAnchor(), 0.8)
		hitbox.disabled = true
	else:
		track.visible = false
		hitbox.disabled = false
		PresetBulletAI.forward(self, rotation)
		damage = speed / 5
		speed *= 1.15
