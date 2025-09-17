extends EntityBase

var masterMine: KukeMC

func register():
	fields[FieldStore.Entity.MAX_HEALTH] = 25
	fields[FieldStore.Entity.MOVEMENT_SPEED] = 0.35
	attackCooldownMap[0] = 500
	attackCooldownMap[1] = 2000
func ai():
	PresetEntityAI.follow(self, currentFocusedBoss, 700)
	tryAttack(0)
	tryAttack(1)
	if timeLived() > 8000:
		masterMine.tryHeal(200)
		tryDie(null)
func attack(type):
	if type == 0:
		BulletBase.generate(preload("res://components/Bullets/PurpleCrystalSmall.tscn"), self, findWeaponAnchor("normal"), position.angle_to_point(currentFocusedBoss.position))
		await TickTool.millseconds(randi_range(5, 25))
	elif type == 1:
		BulletBase.generate(preload("res://components/Bullets/BossAttack/KukeMC/HeavyCrystal.tscn"), self, findWeaponAnchor("normal"), position.angle_to_point(currentFocusedBoss.position))
