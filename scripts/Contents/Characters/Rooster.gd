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
	tryLaunch("attack", 0)
	tryLaunch("attack2", 1)
	tryLaunch("smallSkill", 2)
	tryLaunch("superSkill", 3)
	for i in range(3):
		tryLaunch("cardSkill%d" % i, 4 + i)
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

func tryLaunch(action: String, weaponIndex: int):
	if Input.is_action_just_pressed(action):
		if len(weapons) > weaponIndex:
			var weapon = weapons[weaponIndex]
			if weapon.chargable and weapon.canAttackBy(self):
				chargeStartTime[weaponIndex] = Time.get_ticks_msec()
				chargeParticle.emitting = true
	if Input.is_action_pressed(action):
		if !chargeStartTime.has(weaponIndex):
			tryAttack(weaponIndex)
	if Input.is_action_just_released(action):
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
