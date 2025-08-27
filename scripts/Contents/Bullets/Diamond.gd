extends BulletBase
class_name Diamond

const traceTime = 1000

func ai():
	rotation = lerp_angle(rotation, position.angle_to_point(launcher.currentFocusedBoss.position), 0.2 * ((traceTime - timeLived()) / traceTime))
	canDamageSelf = !(timeLived() >= traceTime)
	forward(Vector2.from_angle(rotation))
