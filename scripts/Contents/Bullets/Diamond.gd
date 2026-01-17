extends BulletBase
class_name Diamond

const traceTime = 1500

func ai():
	PresetBulletAI.forward(self, rotation)
	if timeLived() < traceTime:
		PresetBulletAI.trace(self, launcher.currentFocusedBoss.getTrackingAnchor(), 0.05)
