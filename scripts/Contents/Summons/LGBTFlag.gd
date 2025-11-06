extends SummonBase

var atk: float = 0
var maxTraceTime: float = 0
var tracePower: float = 0

func register():
	fields[FieldStore.Entity.MAX_HEALTH] = 500
	attackCooldownMap[0] = 250
func ai():
	tryAttack(0)
func attack(type):
	if type == 0:
		var tracer = EntityTool.findClosetEntity(position, get_tree(), false, true)
		for bullet in BulletBase.generate(
			ComponentManager.getBullet("LGBTBullet"),
			self,
			findWeaponAnchor("normal"),
			position.angle_to_point(tracer.position)
		):
			bullet.tracer = tracer
			bullet.damage = atk
			bullet.maxTraceTime = maxTraceTime
			bullet.tracePower = tracePower
