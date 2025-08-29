extends BulletBase
class_name Diamond

const traceTime = 2000

func register():
	damage = 2
func ai():
	rotation = lerp_angle(rotation, position.angle_to_point(launcher.currentFocusedBoss.position), 0.1 * clamp((traceTime - timeLived()) / traceTime, 0, INF))
	canDamageSelf = !(timeLived() >= traceTime)
	PresetsAI.forward(self, rotation)
