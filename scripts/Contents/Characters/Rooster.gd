extends EntityBase
class_name Rooster

@onready var chargeParticle: GPUParticles2D = $%chargeParticle

func register():
	attackCooldownMap[0] = 200
	attackCooldownMap[1] = 6000
	hit.connect(
		func(_damage: float, bullet: BulletBase, _crit: bool):
			if bullet is DogCircle:
				EffectController.create(ComponentManager.getEffect("FeatherFall"), texture.global_position).shot()
			elif bullet is FoxZhua:
				EffectController.create(ComponentManager.getEffect("BloodFall"), texture.global_position).shot()
	)
	chargeParticle.emitting = false
var chargeStartTime = {}

func ai():
	texture.play("walk")
	var direction = Vector2(
		Input.get_axis("m_left", "m_right"),
		Input.get_axis("m_up", "m_down")
	)
	move(direction)
	if direction.length() == 0:
		texture.play("idle")
	if Input.is_action_just_pressed("attack"):
		startCharge(0)
	if Input.is_action_just_released("attack"):
		endCharge(0)
	if Input.is_action_just_pressed("attack2"):
		startCharge(1)
	if Input.is_action_just_released("attack2"):
		endCharge(1)
	if Input.is_action_just_pressed("smallSkill"):
		startCharge(2)
	if Input.is_action_just_released("smallSkill"):
		endCharge(2)
	if Input.is_action_just_pressed("superSkill"):
		startCharge(3)
	if Input.is_action_just_released("superSkill"):
		endCharge(3)
	for i in range(3):
		if Input.is_action_just_pressed("cardSkill" + str(i)):
			startCharge(4 + i)
		if Input.is_action_just_released("cardSkill" + str(i)):
			endCharge(4 + i)
	if Input.is_action_just_pressed("sprint"):
		trySprint()
	if Input.is_action_just_pressed("heal"):
		if health < fields.get(FieldStore.Entity.MAX_HEALTH):
			if useItem({
				ItemStore.ItemType.APPLE: 1
			}):
				tryHeal(20)
func sprint():
	move(Vector2(
		Input.get_axis("m_left", "m_right"),
		Input.get_axis("m_up", "m_down")
	) * sprintMultiplier, true)

func startCharge(weaponIndex: int):
	if len(weapons) > weaponIndex:
		var weapon = weapons[weaponIndex]
		if weapon.chargable:
			chargeStartTime[weaponIndex] = Time.get_ticks_msec()
			chargeParticle.emitting = true
func endCharge(weaponIndex: int):
	if chargeStartTime.has(weaponIndex):
		var startTime = chargeStartTime[weaponIndex]
		var endTime = Time.get_ticks_msec()
		var chargedTime = endTime - startTime
		chargeStartTime.erase(weaponIndex)
		if len(weapons) > weaponIndex:
			var weapon = weapons[weaponIndex]
			if weapon.chargable:
				weapon.chargedTime = chargedTime
				tryAttack(weaponIndex)
				chargeParticle.emitting = false
