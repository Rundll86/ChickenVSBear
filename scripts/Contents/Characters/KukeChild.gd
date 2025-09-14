extends EntityBase

var masterMine: KukeMC

func register():
	fields[FieldStore.Entity.MAX_HEALTH] = 25
	fields[FieldStore.Entity.OFFSET_SHOOT] = 5
	fields[FieldStore.Entity.MOVEMENT_SPEED] = 0.25
	attackCooldownMap[0] = 100
func ai():
	PresetEntityAI.follow(self, currentFocusedBoss, 700)
	tryAttack(0)
	if timeLived() > 8000:
		masterMine.tryHeal(50)
		tryDie(null)
func attack(type):
	if type == 0:
		BulletBase.generate(preload("res://components/Bullets/PurpleCrystalSmall.tscn"), self, findWeaponAnchor("normal"), position.angle_to_point(currentFocusedBoss.position))
		await TickTool.millseconds(randi_range(5, 25))
