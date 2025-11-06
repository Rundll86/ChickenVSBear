extends SummonBase

var atk: float = 0
var maxTraceTime: float = 0
var tracePower: float = 0

func register():
	fields[FieldStore.Entity.MAX_HEALTH] = 100
	attackCooldownMap[0] = 500
func ai():
	tryAttack(0)
func attack(type):
	if type == 0:
		for bullet in BulletBase.generate(
			ComponentManager.getBullet("LGBTBullet"),
			self,
			findWeaponAnchor("normal"),
			position.angle_to_point(EntityTool.findClosetEntity(position, get_tree(), false, true).position)
		):
			bullet.damage = atk
			bullet.maxTraceTime = maxTraceTime
			bullet.tracePower = tracePower
