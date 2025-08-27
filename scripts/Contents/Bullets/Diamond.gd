extends BulletBase
class_name Diamond

func ai():
	var tracing = Time.get_ticks_msec() - spawnInWhen < 1000
	if tracing:
		rotation = lerp_angle(rotation, position.angle_to_point(launcher.currentFocusedBoss.position), 0.1)
	canDamageSelf = !tracing
	forward(Vector2.from_angle(rotation))
