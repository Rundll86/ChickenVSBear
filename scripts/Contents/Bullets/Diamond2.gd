extends BulletBase
class_name Diamond2Bullet

@onready var staticSprite: Sprite2D = $%static

func ai():
	if is_instance_valid(parent):
		position = parent.position
	else:
		if animator.is_playing():
			animator.stop(true)
		PresetBulletAI.forward(self, staticSprite.global_rotation)
