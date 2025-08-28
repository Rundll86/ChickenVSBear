extends BulletBase
class_name LockLauncher

enum PositionType {
	SELF,
	TEXTURE,
}

@export var target: PositionType = PositionType.SELF

func ai():
	if target == PositionType.SELF:
		position = launcher.position
	else:
		position = launcher.texture.global_position
	rotation = launcher.rotation
