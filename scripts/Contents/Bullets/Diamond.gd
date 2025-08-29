extends BulletBase
class_name Diamond

const traceTime = 1500

func register():
	damage = 2
func ai():
	canDamageSelf = !(timeLived() >= traceTime)
	PresetAIs.forward(self, rotation)
	if timeLived() < traceTime:
		PresetAIs.trace(self, launcher.currentFocusedBoss.position, 0.05)
