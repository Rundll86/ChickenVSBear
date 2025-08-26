extends EntityBase
class_name Chick

var angle = 0
func _ready():
	fields[FieldStore.Entity.MAX_HEALTH] = 1000
	fields[FieldStore.Entity.MOVEMENT_SPEED] = 0.1
	super._ready()

func ai():
	move(currentFocusedBoss.position - position)
	if tryAttack(0):
		angle += 20
func attack(type):
	if type == 0:
		var weaponPos = findWeaponAnchor("normal")
		BulletBase.generate(preload("res://components/Bullets/Diamond.tscn"), self, weaponPos, deg_to_rad(angle))
