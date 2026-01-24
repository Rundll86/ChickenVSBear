extends EntityBase
class_name KukeMC

var canSummon: bool = true

func spawn():
	texture.play("walk")
func register():
	fields[FieldStore.Entity.MAX_HEALTH] = 3500
	fields[FieldStore.Entity.MOVEMENT_SPEED] = 0.5
	attackCooldownMap[0] = 4000
	attackCooldownMap[1] = 4000
	attackCooldownMap[2] = 20000
	attackCooldownMap[3] = 8000
	inventory[ItemStore.ItemType.APPLE] = INF
	healthChanged.connect(
		func(_h):
			if getHealthPercent() < 0.25:
				canSummon = false
				for child in EntityTool.findEntityByClass("KukeChild", get_tree()):
					if child.masterMine == self:
						child.tryKill()
						tryHeal(percentHealth(0.1))
	)
func ai():
	PresetEntityAI.follow(self, currentFocusedBoss, 500)
	for i in len(attackCooldownMap.keys()):
		tryAttack(i, i in [0])
func attack(type):
	if type == 0:
		for i in randi_range(8, 16):
			fields[FieldStore.Entity.OFFSET_SHOOT] = 25
			for bullet in BulletBase.generate(ComponentManager.getBullet("PurpleCrystal"), self, findWeaponAnchor("normal"), position.angle_to_point(currentFocusedBoss.position)):
				if bullet is BulletBase:
					bullet.baseDamage *= 0.5
			await TickTool.millseconds(randi_range(10, 50))
	elif type == 1 and getHealthPercent() < 0.5 and canSummon:
		for i in randi_range(1, 2):
			var child = EntityBase.generate(ComponentManager.getCharacter("KukeChild"), position + MathTool.sampleInCircle(500))
			child.currentFocusedBoss = currentFocusedBoss
			child.masterMine = self
	elif type == 2:
		var bulletCount = randi_range(20, 40)
		var branchCount = randi_range(1, 3)
		for bulletIndex in bulletCount:
			for branchIndex in branchCount:
				fields[FieldStore.Entity.OFFSET_SHOOT] = 0
				for bullet in BulletBase.generate(ComponentManager.getBullet("PurpleCrystal"), self, findWeaponAnchor("normal"), deg_to_rad(360.0 / bulletCount * bulletIndex + 360.0 / branchCount * branchIndex)):
					if bullet is BulletBase:
						bullet.baseDamage *= 0.5
			await TickTool.millseconds(100)
	elif type == 3:
		BulletBase.generate(ComponentManager.getBullet("HeavyCrystal"), self, findWeaponAnchor("normal"), position.angle_to_point(currentFocusedBoss.position))
