extends BulletBase
class_name VolcanoShadow

func ai():
	speed = initialSpeed * (1 - animator.current_animation_position / animator.current_animation_length)
	PresetBulletAI.forward(self, rotation)
