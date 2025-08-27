extends BulletBase
class_name Diamond

func ai():
	if Time.get_ticks_msec() - spawnInWhen < 500: # 生成的前0.5秒可以追踪
		rotation = lerp_angle(rotation, position.angle_to_point(launcher.currentFocusedBoss.position), 0.1)
	forward(Vector2.from_angle(rotation))
