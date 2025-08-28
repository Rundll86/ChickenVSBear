extends BulletBase
class_name BigLaser

func ai():
	rotation = lerp_angle(rotation, ((get_global_mouse_position() - position).angle()), 0.15)
	position = launcher.texture.global_position
func applyDot():
	hitbox.disabled = true
	await TickTool.millseconds(50)
	hitbox.disabled = false
	await TickTool.millseconds(50)
	return true
