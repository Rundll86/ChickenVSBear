extends EntityBase
class_name Rooster

func _ready():
	super._ready()

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
	if Input.is_action_just_pressed("sprint"):
		trySprint()
func attack(type):
	if type == 0:
		var weaponPos = findWeaponAnchor("normal")
		BulletBase.generate(preload("res://components/Bullets/PurpleCrystal.tscn"), self, weaponPos, (get_global_mouse_position() - weaponPos).angle())
func sprint():
	move(Vector2(
		Input.get_axis("m_left", "m_right"),
		Input.get_axis("m_up", "m_down")
	) * sprintMultiplier, true)
