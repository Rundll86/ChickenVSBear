extends EntityBase

var masterMine: KukeMC

func register():
	fields[FieldStore.Entity.MAX_HEALTH] = 25
	fields[FieldStore.Entity.OFFSET_SHOOT] = 2
	fields[FieldStore.Entity.MOVEMENT_SPEED] = 0.25
	fields[FieldStore.Entity.DAMAGE_MULTIPILER] = 0.1
	attackCooldownMap[0] = 200
func ai():
	PresetEntityAI.follow(self, currentFocusedBoss, 500)
	tryAttack(0)
	if timeLived() > 10000:
		masterMine.tryHeal(100)
		tryDie(null)
func attack(type):
	if type == 0:
		for i in randi_range(1, 3):
			BulletBase.generate(preload("res://components/Bullets/PurpleCrystal.tscn"), self, findWeaponAnchor("normal"), position.angle_to_point(currentFocusedBoss.position))
			await TickTool.millseconds(randi_range(5, 25))
