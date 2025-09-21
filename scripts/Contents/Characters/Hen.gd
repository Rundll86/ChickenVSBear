extends EntityBase
class_name Hen

func register():
	fields[FieldStore.Entity.MAX_HEALTH] = 100
	fields[FieldStore.Entity.MOVEMENT_SPEED] = 0.3
	fields[FieldStore.Entity.OFFSET_SHOOT] = 10

func ai():
	attackCooldownMap[0] = randi_range(1500, 4000)
	PresetEntityAI.follow(self, currentFocusedBoss, 300)
	tryAttack(0)
func attack(type):
	if type == 0:
		var weaponPos = findWeaponAnchor("normal")
		for i in randi_range(1, 4):
			BulletBase.generate(load("res://components/Bullets/Star.tscn"), self, weaponPos, (currentFocusedBoss.position - position).angle())
	return true
