extends SummonBase
class_name GoboSummon

var percent: float = 0.0
var healthSinceLastLaunch: float = 0
var targetDamage: float = 0.0
var count: int = 0

func initHealth(maxHealth: float):
	super.initHealth(maxHealth)
	healthSinceLastLaunch = maxHealth

func register():
	fields[FieldStore.Entity.MOVEMENT_SPEED] = 1.5
	healthChanged.connect(
		func(newHealth):
			if healthSinceLastLaunch - newHealth >= targetDamage:
				launch()
				healthSinceLastLaunch = newHealth
	)
func ai():
	var target = BulletTool.findClosetBulletCanDamage(position, get_tree(), self)
	if is_instance_valid(target):
		move(target.position - position)

func launch():
	ItemDropped.generate(ItemStore.ItemType.APPLE, count, position)
