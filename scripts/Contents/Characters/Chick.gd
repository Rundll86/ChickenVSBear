extends EntityBase
class_name Chick

@onready var firepot = $"%firepot"

const laserCount = 4

func register():
	fields[FieldStore.Entity.MAX_HEALTH] = 1500
	fields[FieldStore.Entity.MOVEMENT_SPEED] = 0.4
	attackCooldownMap[0] = 500
	attackCooldownMap[1] = 6000
	attackCooldownMap[2] = 2000
	attackCooldownMap[3] = 500
	sprintMultiplier = 30
func spawn():
	texture.play("walk")

func ai():
	PresetEntityAI.follow(self, currentFocusedBoss, 0)
	PresetEntityAI.distanceAttack(self, currentFocusedBoss, 0, 200, 2)
	PresetEntityAI.distanceAttack(self, currentFocusedBoss, 200, 700, 1)
	PresetEntityAI.distanceAction(self, currentFocusedBoss, 700, INF,
		func():
			PresetEntityAI.weightAttack(self, [0, 3], [5, 1], func(index): return index == 3)
	)
func attack(type):
	if type == 0:
		var weaponPos = findWeaponAnchor("normal")
		for i in randi_range(10, 20):
			BulletBase.generate(preload("res://components/Bullets/Diamond.tscn"), self, weaponPos + MathTool.randv2_range(20), rotation + deg_to_rad(randf_range(-90, 90)))
	elif type == 1:
		for i in range(laserCount):
			BulletBase.generate(preload("res://components/Bullets/ChickLaser.tscn"), self, texture.global_position, deg_to_rad(90 * i))
	elif type == 2:
		var weaponPos = findWeaponAnchor("normal")
		var target = weaponPos.angle_to_point(currentFocusedBoss.position)
		firepot.global_rotation = target
		firepot.shot()
		BulletBase.generate(preload("res://components/Bullets/FireScan.tscn"), self, weaponPos, target)
	elif type == 3:
		BulletBase.generate(preload("res://components/Bullets/ChickSprint.tscn"), self, position, 0)
		trySprint()
	return true
func sprint():
	move((currentFocusedBoss.position - position).normalized() * sprintMultiplier, true)
