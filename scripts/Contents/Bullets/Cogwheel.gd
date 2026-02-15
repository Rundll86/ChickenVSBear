extends BulletBase
class_name CogwheelBullet

var initialRotate: float = 0
var rotateSpeed: float = 0
var dotTime: float = 0
var slow: float = 0.2

func ai():
	PresetBulletAI.forward(self, rotation)
	texture.rotation_degrees += rotateSpeed
	if rotateSpeed < 0:
		speed += slow
		PresetBulletAI.trace(self, launcher.position, 0.1)
		if position.distance_to(launcher.position) < 100:
			tryDestroy()
	else:
		speed = initialSpeed * (rotateSpeed / initialRotate)
	dotTime = 1000 / (rotateSpeed)
	rotateSpeed -= slow
func applyDot():
	hitbox.disabled = true
	await TickTool.frame()
	hitbox.disabled = false
	await TickTool.millseconds(dotTime / launcher.fields[FieldStore.Entity.ATTACK_SPEED])
	await TickTool.frame() # 等至少一帧，防止跳帧导致没检测到伤害
	return true

func refract(newBullet: BulletBase, _entity: EntityBase, _index: int, _total: int, _lastBullet: float):
	if newBullet is CogwheelBullet:
		newBullet.rotateSpeed = initialRotate
	return newBullet
