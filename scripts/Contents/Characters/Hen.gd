extends EntityBase
class_name Hen

func _ready():
	fields[FieldStore.Entity.MAX_HEALTH] = 75
	fields[FieldStore.Entity.MOVEMENT_SPEED] = 0.25
	super._ready()

func ai():
	move(currentFocusedBoss.position - position)
	tryAttack(0)
func attack(type):
	if type == 0:
		var weaponPos = findWeaponAnchor("normal")
		for i in randi_range(1, 4):
			BulletBase.generate(preload("res://components/Bullets/Star.tscn"), self, weaponPos, randf_range(0, PI * 2))
	return true
