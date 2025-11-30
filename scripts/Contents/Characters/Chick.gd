extends EntityBase
class_name Chick

var played: bool = false

func register():
	fields[FieldStore.Entity.MAX_HEALTH] = 2500
	fields[FieldStore.Entity.MOVEMENT_SPEED] = 0.4
	attackCooldownMap[0] = 400
	attackCooldownMap[1] = 12000
	attackCooldownMap[2] = 2000
	attackCooldownMap[3] = 3000
	attackCooldownMap[4] = 4000
	sprintMultiplier = 50
	healthChanged.connect(
		func(h):
			if !played and h <= fields.get(FieldStore.Entity.MAX_HEALTH) * 0.1:
				played = true
				playSound("readyToDie")
	)
func spawn():
	texture.play("walk")

func ai():
	tryAttack(4)
	PresetEntityAI.follow(self, currentFocusedBoss, 0)
	PresetEntityAI.distanceAttack(self, currentFocusedBoss, 0, 500, 2)
	PresetEntityAI.distanceAttack(self, currentFocusedBoss, 500, 1000, 1)
	PresetEntityAI.distanceAction(self, currentFocusedBoss, 1000, INF,
		func():
			PresetEntityAI.weightAttack(self, [0, 3], [5, 1], func(index): return index == 3)
	)
func attack(type):
	if type == 0:
		var weaponPos = findWeaponAnchor("normal")
		for i in randi_range(7, 16):
			BulletBase.generate(ComponentManager.getBullet("Diamond"), self, weaponPos + MathTool.randv2_range(20), rotation + deg_to_rad(randf_range(-90, 90)))
	elif type == 1:
		var laserCount = randi_range(2, 4)
		for i in laserCount:
			BulletBase.generate(ComponentManager.getBullet("ChickLaser"), self, texture.global_position, deg_to_rad(360.0 / laserCount * i))
	elif type == 2:
		var weaponPos = findWeaponAnchor("normal")
		BulletBase.generate(ComponentManager.getBullet("FireScan"), self, weaponPos, weaponPos.angle_to_point(currentFocusedBoss.getTrackingAnchor()))
	elif type == 3:
		BulletBase.generate(ComponentManager.getBullet("ChickSprint"), self, position, 0)
		trySprint()
	elif type == 4:
		BulletBase.generate(ComponentManager.getBullet("FoxZhua"), self, findWeaponAnchor("foot"), deg_to_rad(90))
	return true
func sprint():
	move((currentFocusedBoss.position - position).normalized() * sprintMultiplier, true)
