extends EntityBase
class_name Bear

func ai():
	pass
func attack(type):
	if type == 0:
		var weaponPos = findWeaponAnchor("normal")
		return BulletBase.generate(preload("res://components/Bullets/PurpleCrystal.tscn"), self, weaponPos, (get_global_mouse_position() - weaponPos).angle())
func sprint():
	move(Vector2(
		Input.get_axis("m_left", "m_right"),
		Input.get_axis("m_up", "m_down")
	) * sprintMultiplier, true)
func heal(count: float):
	health += count
	DamageLabel.create(-count, false, damageAnchor.global_position + MathTool.randv2_range(GameRule.damageLabelSpawnOffset))
