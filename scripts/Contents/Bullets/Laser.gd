extends BulletBase
class_name Laser

func ai():
	rotation_degrees += 5
	position = launcher.texture.global_position
