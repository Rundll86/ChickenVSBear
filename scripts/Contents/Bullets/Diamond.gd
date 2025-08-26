extends BulletBase
class_name Diamond

func ai():
	rotation_degrees += 1
	forward(Vector2.from_angle(rotation))
