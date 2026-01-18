extends EntityBase

func register():
	fields[FieldStore.Entity.MAX_HEALTH] = 120
	fields[FieldStore.Entity.MOVEMENT_SPEED] = 0.2
	fields[FieldStore.Entity.OFFSET_SHOOT] = 0
	attackCooldownMap[0] = randi_range(3000, 5000)
func spawn():
	texture.play("walk")
func ai():
	PresetEntityAI.follow(self, currentFocusedBoss, 300)
	tryAttack(0)
func attack(type):
	if type == 0:
		var weaponPos = findWeaponAnchor("normal")
		var angle = weaponPos.angle_to_point(currentFocusedBoss.position)
		for i in 3:
			BulletBase.generate(ComponentManager.getBullet("DogCircle"), self, weaponPos, angle)
			await TickTool.millseconds(100)
	return true
