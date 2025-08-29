extends BulletBase
class_name FireScan

func register():
	speed = 5
	damage = 20

func ai():
	forward(Vector2.from_angle(rotation))
