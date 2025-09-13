extends EntityBase
class_name Bear # 攻击方式模仿泰拉瑞亚光之女皇

@onready var sprintParticle: GPUParticles2D = $"%sprintParticle"

func register():
	fields[FieldStore.Entity.MAX_HEALTH] = 2000
	fields[FieldStore.Entity.MOVEMENT_SPEED] = 0.5
	attackCooldownMap[0] = 3000
	attackCooldownMap[1] = 10000
	attackCooldownMap[2] = 8000
	attackCooldownMap[3] = 13000
	attackCooldownMap[4] = 4500
	sprintMultiplier = 60
func spawn():
	texture.play("walk")
func ai():
	PresetEntityAI.follow(self, currentFocusedBoss, 200)
	for i in len(attackCooldownMap.keys()):
		tryAttack(i)
func attack(type):
	var weaponPos = findWeaponAnchor("normal")
	if type == 0:
		playSound("attack0")
		for i in randi_range(20, 30):
			for bullet in BulletBase.generate(preload("res://components/Bullets/BossAttack/Bear/ArrowSeven.tscn"), self, findWeaponAnchor("normal"), deg_to_rad(randf_range(0, 360))):
				bullet.tracer = currentFocusedBoss
				bullet.position += MathTool.randv2_range(50)
			await TickTool.millseconds(50)
		return false
	elif type == 1:
		await sprintTo(currentFocusedBoss.position - Vector2(MathTool.randc_from([-300, 300]), 300), 0.25)
		var count = randi_range(6, 8)
		for i in range(count):
			BulletBase.generate(preload("res://components/Bullets/BossAttack/Bear/SunDance.tscn"), self, weaponPos, deg_to_rad(360.0 / count * i))
	elif type == 2:
		for i in range(13):
			for bullet in BulletBase.generate(preload("res://components/Bullets/BossAttack/Bear/ForeverRainbow.tscn"), self, weaponPos, 0):
				bullet.rotation = 360 / 13.0 * i
	elif type == 3:
		await sprintTo(currentFocusedBoss.position - Vector2(MathTool.randc_from([500, -500]), 0), 0.25)
		playSound("attack3")
		sprintParticle.emitting = true
		canRunAi = false
		await TickTool.millseconds(900)
		BulletBase.generate(preload("res://components/Bullets/BearSprint.tscn"), self, weaponPos, 0)
		await trySprint()
		sprintParticle.emitting = false
		canRunAi = true
		await sprintTo(currentFocusedBoss.position + MathTool.randv2_range(400), 0.25)
		return false
	elif type == 4:
		playSound("attack4")
		var count = randi_range(8, 12)
		for i in range(count):
			for bullet in BulletBase.generate(preload("res://components/Bullets/BossAttack/Bear/ArrowSeven.tscn"), self, findWeaponAnchor("normal"), deg_to_rad(360.0 / count * i)):
				bullet.tracer = currentFocusedBoss
			await TickTool.millseconds(830.0 / count)
		return false
	return true
func sprint():
	move(Vector2(sign((currentFocusedBoss.position - position).x * sprintMultiplier), 0), true)
