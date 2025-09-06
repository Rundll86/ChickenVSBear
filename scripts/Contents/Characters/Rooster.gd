extends EntityBase
class_name Rooster

func register():
	attackCooldownMap[0] = 200
	attackCooldownMap[1] = 6000
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
	elif Input.is_action_pressed("attack2"):
		tryAttack(1)
	if Input.is_action_just_pressed("sprint"):
		trySprint()
	if Input.is_action_just_pressed("heal"):
		tryHeal(20)
func sprint():
	move(Vector2(
		Input.get_axis("m_left", "m_right"),
		Input.get_axis("m_up", "m_down")
	) * sprintMultiplier, true)
func heal(count: float):
	health += count
	DamageLabel.create(-count, false, damageAnchor.global_position + MathTool.randv2_range(GameRule.damageLabelSpawnOffset))
	return count
