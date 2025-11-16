extends BulletBase
class_name Volcano

var rotates: float = 0

func register():
	animator.speed_scale = launcher.fields.get(FieldStore.Entity.ATTACK_SPEED)
func ai():
	PresetBulletAI.lockLauncher(self, launcher, true)
	rotation = lerp_angle(
		rotation,
		position.angle_to_point(get_global_mouse_position()),
		rotates
	)
