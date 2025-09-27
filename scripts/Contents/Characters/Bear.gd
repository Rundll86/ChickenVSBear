extends EntityBase
class_name Bear

@onready var sprintParticle: GPUParticles2D = $"%sprintParticle"
@onready var mask: Sprite2D = $"%mask"

func register():
	fields[FieldStore.Entity.MAX_HEALTH] = 1000
	fields[FieldStore.Entity.MOVEMENT_SPEED] = 0.5
	fields[FieldStore.Entity.OFFSET_SHOOT] = 0
	attackCooldownMap[0] = 3000
	attackCooldownMap[1] = 10000
	attackCooldownMap[2] = 8000
	attackCooldownMap[3] = 13000
	attackCooldownMap[4] = 4500
	attackCooldownMap[5] = 5500
	attackCooldownMap[6] = 10000
	attackCooldownMap[7] = 9000
	healthChanged.connect(
		func(newHealth):
			setStage(1 if newHealth < fields[FieldStore.Entity.MAX_HEALTH] * 0.5 else 0)
	)
func spawn():
	texture.play("walk")
	mask.visible = false
func ai():
	PresetEntityAI.follow(self, currentFocusedBoss, 400)
	for i in len(attackCooldownMap.keys()):
		tryAttack(i)
func enterStage(stage):
	mask.visible = !!stage
	fields[FieldStore.Entity.MOVEMENT_SPEED] = 0.75
	fields[FieldStore.Entity.DAMAGE_MULTIPILER] = 1.5
	fields[FieldStore.Entity.ATTACK_SPEED] = 2
	await TickTool.millseconds(2000)
func attack(type):
	var weaponPos = findWeaponAnchor("normal")
	if type == 0:
		playSound("attack0")
		for i in randi_range(20, 30):
			if !is_instance_valid(currentFocusedBoss): return false
			for bullet in BulletBase.generate(ComponentManager.getBullet("ArrowSeven"), self, findWeaponAnchor("normal"), deg_to_rad(randf_range(0, 360))):
				bullet.tracer = currentFocusedBoss
				bullet.position += MathTool.randv2_range(50)
			await TickTool.millseconds(50)
		return false
	elif type == 1:
		await sprintTo(currentFocusedBoss.position - Vector2(MathTool.randc_from([-300, 300]), 300), 0.25)
		var count = randi_range(6, 8)
		for i in range(count):
			BulletBase.generate(ComponentManager.getBullet("SunDance"), self, weaponPos, deg_to_rad(360.0 / count * i))
	elif type == 2:
		for i in range(13):
			for bullet in BulletBase.generate(ComponentManager.getBullet("ForeverRainbow"), self, weaponPos, 0):
				bullet.rotation = 360 / 13.0 * i
	elif type == 3:
		if !is_instance_valid(currentFocusedBoss): return false
		await sprintTo(currentFocusedBoss.position - Vector2(MathTool.randc_from([500, -500]), 0), 0.25)
		sprintParticle.emitting = true
		canRunAi = false
		currentInvinsible = true
		playSound("attack3")
		await TickTool.millseconds(500)
		BulletBase.generate(ComponentManager.getBullet("BearSprint"), self, weaponPos, 0)
		await trySprint()
		sprintParticle.emitting = false
		canRunAi = true
		await sprintTo(currentFocusedBoss.position + MathTool.randv2_range(400), 0.25)
		currentInvinsible = false
		return false
	elif type == 4:
		playSound("attack4")
		var count = randi_range(8, 12)
		for i in range(count):
			if !is_instance_valid(currentFocusedBoss): return false
			for bullet in BulletBase.generate(ComponentManager.getBullet("ArrowSeven"), self, findWeaponAnchor("normal"), deg_to_rad(360.0 / count * i)):
				bullet.tracer = currentFocusedBoss
			await TickTool.millseconds(830.0 / count)
		return false
	elif type == 5:
		playSound("attack5")
		var count = randi_range(20, 30)
		for i in range(count):
			if !is_instance_valid(currentFocusedBoss): return false
			for bullet in BulletBase.generate(ComponentManager.getBullet("LightGun"), self, currentFocusedBoss.position, 0):
				bullet.rotation = deg_to_rad(360.0 / count * i)
			await TickTool.millseconds(1670.0 / count)
		return false
	elif type == 6:
		playSound("attack6")
		for i in 16:
			if !is_instance_valid(currentFocusedBoss): return false
			for bullet in BulletBase.generate(ComponentManager.getBullet("LightGun"), self, currentFocusedBoss.position, 0):
				bullet.position += MathTool.randv2_range(600)
				bullet.look_at(currentFocusedBoss.position + MathTool.randv2_range(50))
			await TickTool.millseconds(100)
		return false
	elif type == 7:
		var angle = deg_to_rad(70)
		for j in 4:
			var initAngle = randf_range(0, 360)
			if !is_instance_valid(currentFocusedBoss): return false
			playSound("attack7")
			for i in 16:
				for bullet in BulletBase.generate(ComponentManager.getBullet("LightGun"), self, currentFocusedBoss.position, 0):
					bullet.rotation_degrees += initAngle
					bullet.rotation -= angle / 2
					bullet.rotation += angle / 16 * i
					bullet.look_at(currentFocusedBoss.position)
			await TickTool.millseconds(1000)
		return false
	return true
func sprint():
	var dir = sign((currentFocusedBoss.position - position).x)
	velocity = Vector2(dir, 0)
func sprintAi():
	velocity.x *= 1.2
	return abs(velocity.x) >= 1000000
