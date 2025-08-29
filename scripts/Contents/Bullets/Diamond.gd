extends BulletBase
class_name Diamond

const traceTime = 1500

func register():
	damage = 2
func ai():
	canDamageSelf = !(timeLived() >= traceTime)
	PresetsAI.forward(self, rotation)
	if timeLived() < traceTime:
		PresetsAI.trace(self, launcher.currentFocusedBoss.position, 0.05)
