extends BulletBase
class_name Star

func register():
	damage = 1
func ai():
	forward(Vector2.from_angle(rotation))
