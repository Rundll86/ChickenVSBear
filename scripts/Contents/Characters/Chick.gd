extends EntityBase
class_name Chick

@onready var firepot = $"%firepot"

var angle = 0

func _ready():
	fields[FieldStore.Entity.MAX_HEALTH] = 1000
	fields[FieldStore.Entity.MOVEMENT_SPEED] = 0.1
	super._ready()

func ai():
	move(currentFocusedBoss.position - position)
	if currentFocusedBoss.position.distance_to(position) < 300:
		tryAttack(1)
	else:
		if tryAttack(0):
			angle += 20
func attack(type):
	if type == 0:
		var weaponPos = findWeaponAnchor("normal")
		BulletBase.generate(preload("res://components/Bullets/Diamond.tscn"), self, weaponPos, deg_to_rad(angle))
	elif type == 1:
		var weaponPos = findWeaponAnchor("normal")
		var target = weaponPos.angle_to_point(currentFocusedBoss.position)
		firepot.global_rotation = target
		firepot.shot()
		BulletBase.generate(preload("res://components/Bullets/FireScan.tscn"), self, weaponPos, target)
