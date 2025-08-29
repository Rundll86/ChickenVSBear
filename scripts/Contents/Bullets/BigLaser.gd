extends BulletBase
class_name BigLaser # 这个子弹是玩家的超级武器，耗能高，dps也高

func register():
	speed = 0
	damage = 35
	penerate = 1
func spawn():
	CameraManager.shake(5000, 150) # 激光会运行5秒（5000毫秒），期间震屏超高强度
	CameraManager.playAnimation("bigLaser")
	damage *= launcher.fields[FieldStore.Entity.ATTACK_SPEED]
func ai():
	rotation = lerp_angle(rotation, ((get_global_mouse_position() - position).angle()), 0.1)
	position = launcher.texture.global_position
func applyDot():
	hitbox.disabled = true
	await TickTool.millseconds(100 / launcher.fields[FieldStore.Entity.ATTACK_SPEED])
	hitbox.disabled = false
	await TickTool.millseconds(100 / launcher.fields[FieldStore.Entity.ATTACK_SPEED])
	return true
