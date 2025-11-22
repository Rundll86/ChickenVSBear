extends BulletBase
class_name FoxZhua

@export var canTrace: bool = true

func ai():
	if canTrace:
		PresetBulletAI.lerpPosition(self, launcher.currentFocusedBoss.getTrackingAnchor() - Vector2(0, 200), speed)