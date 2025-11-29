extends SummonBase

var maxTraceTime: float = 0
var tracePower: float = 0
var count: int = 0
var angle: float = 0

func register():
	attackCooldownMap[0] = 1000
func ai():
	tryAttack(0)
func attack(type):
	if type == 0:
		var tracer = EntityTool.findClosetEntity(position, get_tree(), false, true)
		var startAngle = position.angle_to_point(tracer.getTrackingAnchor()) + deg_to_rad(randf_range(-1, 1) * 45)
		for i in count:
			if !is_instance_valid(tracer):
				break
			for bullet in BulletBase.generate(
				ComponentManager.getBullet("LGBTBullet"),
				myMaster,
				findWeaponAnchor("normal"),
				startAngle + deg_to_rad(i * angle)
			):
				if bullet is LGBTBullet:
					bullet.tracer = tracer
					bullet.baseDamage = atk
					bullet.maxTraceTime = maxTraceTime
					bullet.tracePower = tracePower
			await TickTool.millseconds(50)
