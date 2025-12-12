extends BulletBase
class_name Diamond2Bullet

func ai():
	if is_instance_valid(parent):
		position = parent.position
