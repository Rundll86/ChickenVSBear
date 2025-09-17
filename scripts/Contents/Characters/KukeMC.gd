extends EntityBase
class_name KukeMC

func register():
	fields[FieldStore.Entity.MAX_HEALTH] = 2500
	fields[FieldStore.Entity.MOVEMENT_SPEED] = 0.5
	attackCooldownMap[0] = 2000
	attackCooldownMap[1] = 5000
	attackCooldownMap[2] = 6000
	attackCooldownMap[3] = 2000
	inventory[ItemStore.ItemType.APPLE] = INF
func ai():
	PresetEntityAI.follow(self, currentFocusedBoss, 500)
	for bullet in get_tree().get_nodes_in_group("bullets"):
		if (
			bullet is LGBTBullet and
			bullet.position.distance_to(self.position) < 200
		):
			bullet.tryDestroy()
	# for i in len(attackCooldownMap.keys()):
	# 	tryAttack(i)
	tryAttack(3)
func attack(type):
	if type == 0:
		for i in randi_range(8, 16):
			fields[FieldStore.Entity.OFFSET_SHOOT] = 25
			BulletBase.generate(preload("res://components/Bullets/PurpleCrystal.tscn"), self, findWeaponAnchor("normal"), position.angle_to_point(currentFocusedBoss.position))
			await TickTool.millseconds(randi_range(10, 50))
	elif type == 1:
		for i in randi_range(1, 2):
			var child = EntityBase.generate(preload("res://components/Characters/KukeChild.tscn"), position + MathTool.randv2_range(500))
			child.currentFocusedBoss = currentFocusedBoss
			child.masterMine = self
	elif type == 2:
		var count = randi_range(20, 40)
		for i in count:
			var count1 = 3
			for j in count1:
				fields[FieldStore.Entity.OFFSET_SHOOT] = 0
				BulletBase.generate(preload("res://components/Bullets/PurpleCrystal.tscn"), self, findWeaponAnchor("normal"), deg_to_rad(360.0 / count * i + 360.0 / count1 * j))
			await TickTool.millseconds(100)
	elif type == 3:
		BulletBase.generate(preload("res://components/Bullets/BossAttack/KukeMC/HeavyCrystal.tscn"), self, findWeaponAnchor("normal"), position.angle_to_point(currentFocusedBoss.position))
