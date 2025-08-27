extends BulletBase
class_name Star

func ai():
	forward(Vector2.from_angle(rotation))
