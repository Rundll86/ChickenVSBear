extends EntityBase
class_name KukeMC

func register():
	fields[FieldStore.Entity.MAX_HEALTH] = 3500
	fields[FieldStore.Entity.OFFSET_SHOOT] = 25
	fields[FieldStore.Entity.MOVEMENT_SPEED] = 0.5
	attackCooldownMap[0] = 8000
	attackCooldownMap[1] = 5000
func ai():
	PresetEntityAI.follow(self, currentFocusedBoss, 500)
	for bullet in get_tree().get_nodes_in_group("bullets"):
		if (
			bullet is LGBTBullet and
			bullet.position.distance_to(self.position) < 200 # 酷可mc会去摧毁200半径以内的七彩飞星
		):
			bullet.tryDestroy()
	for i in len(attackCooldownMap.keys()):
		tryAttack(i)
func attack(type):
	if type == 0:
		for i in randi_range(8, 16):
			BulletBase.generate(preload("res://components/Bullets/PurpleCrystal.tscn"), self, findWeaponAnchor("normal"), position.angle_to_point(currentFocusedBoss.position))
			await TickTool.millseconds(randi_range(10, 50))
	elif type == 1:
		for i in randi_range(1, 2):
			var child = EntityBase.generate(preload("res://components/Characters/KukeChild.tscn"), position + MathTool.randv2_range(500))
			child.currentFocusedBoss = currentFocusedBoss
			child.masterMine = self
