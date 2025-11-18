extends BulletBase
class_name Bow

var count: int = 0
var atk: float = 0
var waitTime: float = 2000

func spawn():
	var startAngle = rotation - deg_to_rad(count * 10.0 / 2)
	for c in count:
		for i in BulletBase.generate(
			ComponentManager.getBullet("Arrow"),
			launcher,
			position,
			startAngle + deg_to_rad(c * 10.0)
		):
			var bullet: Arrow = i
			bullet.atk = atk
			bullet.waitTime = waitTime
	await TickTool.millseconds(waitTime)
	tryDestroy()
func ai():
	PresetBulletAI.lockLauncher(self, launcher, true)
	rotation = position.angle_to_point(get_global_mouse_position())
