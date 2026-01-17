extends EntityBase
class_name Rooster

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
	if !WorldManager.isRelease():
		fields[FieldStore.Entity.BULLET_SPLIT] = 2
		fields[FieldStore.Entity.BULLET_REFRACTION] = 2
func ai():
	texture.play("walk")
	var direction = Vector2(
		Input.get_axis("m_left", "m_right"),
		Input.get_axis("m_up", "m_down")
	)
	move(direction)
	if direction.length() == 0:
		texture.play("idle")
	if Input.is_action_pressed("attack"):
		tryAttack(0)
	if Input.is_action_pressed("attack2"):
		tryAttack(1)
	if Input.is_action_pressed("smallSkill"):
		tryAttack(2)
	if Input.is_action_pressed("superSkill"):
		tryAttack(3)
	for i in range(3):
		if Input.is_action_pressed("cardSkill" + str(i)):
			tryAttack(4 + i)
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
