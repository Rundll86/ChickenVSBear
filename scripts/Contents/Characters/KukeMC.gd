extends EntityBase
class_name KukeMC

var canSummon: bool = true

func register():
	fields[FieldStore.Entity.MAX_HEALTH] = 3500
	fields[FieldStore.Entity.MOVEMENT_SPEED] = 0.5
	attackCooldownMap[0] = 2000
	attackCooldownMap[1] = 5000
	attackCooldownMap[2] = 20000
	attackCooldownMap[3] = 2000
	inventory[ItemStore.ItemType.APPLE] = INF
	healthChanged.connect(
		func(h):
			if h < fields[FieldStore.Entity.MAX_HEALTH] * 0.25:
				canSummon = false
				for child in EntityTool.findEntityByClass("KukeChild", get_tree()):
					if child.masterMine == self:
						child.tryKill()
						tryHeal(200)
	)
func ai():
	PresetEntityAI.follow(self, currentFocusedBoss, 500)
	for i in len(attackCooldownMap.keys()):
		tryAttack(i)
func attack(type):
	if type == 0:
		for i in randi_range(8, 16):
			fields[FieldStore.Entity.OFFSET_SHOOT] = 25
			for bullet in BulletBase.generate(ComponentManager.getBullet("PurpleCrystal"), self, findWeaponAnchor("normal"), position.angle_to_point(currentFocusedBoss.position)):
				if bullet is BulletBase:
					bullet.baseDamage *= 0.5
			await TickTool.millseconds(randi_range(10, 50))
	elif type == 1 and health < fields[FieldStore.Entity.MAX_HEALTH] * 0.5 and canSummon:
		for i in randi_range(1, 2):
			var child = EntityBase.generate(ComponentManager.getCharacter("KukeChild"), position + MathTool.randv2_range(500))
			child.currentFocusedBoss = currentFocusedBoss
			child.masterMine = self
	elif type == 2:
		var countOfBullet = randi_range(40, 50)
		var countOfBranch = randi_range(1, 3)
		for bulletIndex in countOfBullet:
			for branchIndex in countOfBranch:
				fields[FieldStore.Entity.OFFSET_SHOOT] = 0
				for bullet in BulletBase.generate(ComponentManager.getBullet("PurpleCrystal"), self, findWeaponAnchor("normal"), deg_to_rad(360.0 / countOfBullet * bulletIndex + 360.0 / countOfBranch * branchIndex)):
					if bullet is BulletBase:
						bullet.baseDamage *= 0.5
			await TickTool.millseconds(100)
	elif type == 3:
		BulletBase.generate(ComponentManager.getBullet("HeavyCrystal"), self, findWeaponAnchor("normal"), position.angle_to_point(currentFocusedBoss.position))
