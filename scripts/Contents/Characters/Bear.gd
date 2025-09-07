extends EntityBase
class_name Bear # 攻击方式模仿泰拉瑞亚光之女皇

func register():
	fields[FieldStore.Entity.MAX_HEALTH] = 2000
	fields[FieldStore.Entity.MOVEMENT_SPEED] = 0.25
	attackCooldownMap[0] = 100
	attackCooldownMap[1] = 100
func spawn():
	texture.play("walk")
func ai():
	PresetEntityAI.follow(self, currentFocusedBoss, 0)
	tryAttack(0)
	tryAttack(1)
func attack(type):
	var weaponPos = findWeaponAnchor("normal")
	if type == 0:
		for bullet in BulletBase.generate(preload("res://components/Bullets/BossAttack/Bear/ArrowSeven.tscn"), self, weaponPos, deg_to_rad(randf_range(0, 360))):
			bullet.tracer = currentFocusedBoss
	elif type == 1:
		for bullet in BulletBase.generate(preload("res://components/Bullets/BossAttack/Bear/SunDance.tscn"), self, weaponPos, deg_to_rad(randf_range(0, 360))):
			bullet.damage = 1
	return true
