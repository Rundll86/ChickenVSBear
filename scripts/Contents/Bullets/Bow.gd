extends BulletBase
class_name Bow

var count: int = 0
var atk: float = 0

func spawn():
	await TickTool.millseconds(1000)
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
	tryDestroy()
func ai():
	PresetBulletAI.lockLauncher(self, launcher, true)
	rotation = position.angle_to_point(get_global_mouse_position())
