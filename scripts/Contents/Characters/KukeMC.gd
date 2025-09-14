extends EntityBase
class_name KukeMC
func register():
	fields[FieldStore.Entity.MAX_HEALTH] = 2500
	fields[FieldStore.Entity.OFFSET_SHOOT] = 15
	fields[FieldStore.Entity.MOVEMENT_SPEED] = 0.5
	attackCooldownMap[0] = 2000
func ai():
	PresetEntityAI.follow(self, currentFocusedBoss, 500)
	for bullet in get_tree().get_nodes_in_group("bullets"):
		if (
			bullet is LGBTBullet and
			bullet.position.distance_to(self.position) < 200 # 酷可mc会去摧毁200半径以内的七彩飞星
		):
			bullet.tryDestroy()
	tryAttack(0)
func attack(type):
	if type == 0:
		for i in randi_range(8, 16):
			BulletBase.generate(preload("res://components/Bullets/PurpleCrystal.tscn"), self, findWeaponAnchor("normal"), position.angle_to_point(currentFocusedBoss.position))
			await TickTool.millseconds(randi_range(10, 50))
