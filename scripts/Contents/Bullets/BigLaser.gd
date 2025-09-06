extends BulletBase
class_name BigLaser

var dotTime: float = 100

func register():
	speed = 0
	penerate = 1
func spawn():
	CameraManager.shake(5000, 100) # 激光会运行5秒（5000毫秒），期间震屏超高强度
	CameraManager.playAnimation("bigLaser")
	damage *= launcher.fields[FieldStore.Entity.ATTACK_SPEED]
func ai():
	rotation = lerp_angle(rotation, ((get_global_mouse_position() - position).angle()), 0.1)
	position = launcher.texture.global_position
func applyDot():
	hitbox.disabled = true
	await TickTool.millseconds(dotTime / launcher.fields[FieldStore.Entity.ATTACK_SPEED])
	hitbox.disabled = false
	await TickTool.millseconds(dotTime / launcher.fields[FieldStore.Entity.ATTACK_SPEED])
	await TickTool.frame() # 等至少一帧，防止跳帧导致没检测到伤害
	return true
