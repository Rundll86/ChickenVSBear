extends BulletBase
class_name BigLaser # 这个子弹是玩家的超级武器，耗能高，dps也高

func spawn():
	CameraManager.shake(5000, 100) # 激光会运行5秒，期间震屏100强度
	CameraManager.playAnimation("bigLaser")
	fields[FieldStore.Bullet.DAMAGE] *= launcher.fields[FieldStore.Entity.ATTACK_SPEED]
func ai():
	rotation = lerp_angle(rotation, ((get_global_mouse_position() - position).angle()), 0.1)
	position = launcher.texture.global_position
func applyDot():
	hitbox.disabled = true
	await TickTool.millseconds(100 / launcher.fields[FieldStore.Entity.ATTACK_SPEED])
	hitbox.disabled = false
	await TickTool.millseconds(100 / launcher.fields[FieldStore.Entity.ATTACK_SPEED])
	return true
func succeedToHit(_dmg: float):
	fields[FieldStore.Bullet.DAMAGE] *= 1.05
