extends SummonBase
class_name GoboSummon

var percent: float = 0.0
var healthSinceLastLaunch: float = 0

func initHealth(maxHealth: float):
	super.initHealth(maxHealth)
	healthSinceLastLaunch = maxHealth

func register():
	fields[FieldStore.Entity.MOVEMENT_SPEED] = 1.5
	healthChanged.connect(
		func(newHealth):
			if healthSinceLastLaunch - newHealth >= 1:
				launch()
				healthSinceLastLaunch = newHealth
	)
func ai():
	var target = BulletTool.findClosetBulletCanDamage(position, get_tree(), self)
	if is_instance_valid(target):
		move(target.position - position)

func launch():
	for bullet in BulletBase.generate(
		ComponentManager.getBullet("HealingMissle"),
		self,
		position,
		position.angle_to_point(EntityTool.findClosetEntity(myMaster.position, get_tree(), isPlayer(), !isPlayer(), [self]).position)
	):
		if bullet is HealingMissleBullet:
			bullet.baseDamage = health * percent * -1
