extends EntityBase
class_name KukeMC
func register():
	fields[FieldStore.Entity.MAX_HEALTH] = 1000
	fields[FieldStore.Entity.OFFSET_SHOOT] = 45
	attackCooldownMap[0] = 500
func ai():
	for bullet in get_tree().get_nodes_in_group("bullets"):
		if (
			bullet is LGBTBullet and
			bullet.position.distance_to(self.position) < 200 # 酷可mc会去摧毁200半径以内的七彩飞星
		):
			bullet.tryDestroy()
	tryAttack(0)
func attack(type):
	if type == 0:
		for i in randi_range(3, 8):
			BulletBase.generate(preload("res://components/Bullets/PurpleCrystal.tscn"), self, findWeaponAnchor("normal"), position.angle_to_point(currentFocusedBoss.position))
