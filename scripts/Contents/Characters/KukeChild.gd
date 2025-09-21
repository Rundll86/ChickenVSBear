extends EntityBase
class_name KukeChild

var masterMine: KukeMC

func register():
	fields[FieldStore.Entity.MAX_HEALTH] = 25
	fields[FieldStore.Entity.MOVEMENT_SPEED] = 0.35
	attackCooldownMap[0] = 100
	attackCooldownMap[1] = 8000
func ai():
	PresetEntityAI.follow(self, currentFocusedBoss, 700)
	tryAttack(0)
	tryAttack(1)
	if timeLived() > 10000:
		tryKill()
func attack(type):
	if type == 0:
		BulletBase.generate(load("res://components/Bullets/PurpleCrystalSmall.tscn"), self, findWeaponAnchor("normal"), position.angle_to_point(currentFocusedBoss.position))
		await TickTool.millseconds(randi_range(5, 25))
	elif type == 1:
		BulletBase.generate(load("res://components/Bullets/BossAttack/KukeMC/HeavyCrystal.tscn"), self, findWeaponAnchor("normal"), position.angle_to_point(currentFocusedBoss.position))
func kill():
	masterMine.tryHeal(100)
