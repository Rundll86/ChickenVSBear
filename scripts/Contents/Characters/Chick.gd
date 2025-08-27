extends EntityBase
class_name Chick

@onready var firepot = $"%firepot"

func _ready():
	fields[FieldStore.Entity.MAX_HEALTH] = 1000
	fields[FieldStore.Entity.MOVEMENT_SPEED] = 0.1
	super._ready()

func ai():
	move(currentFocusedBoss.position - position)
	if currentFocusedBoss.position.distance_to(position) < 300:
		tryAttack(1)
	else:
		tryAttack(0)
func attack(type):
	if type == 0:
		var weaponPos = findWeaponAnchor("normal")
		BulletBase.generate(preload("res://components/Bullets/Diamond.tscn"), self, weaponPos, rotation + deg_to_rad(MathTool.randc_from([-90, 90])))
	elif type == 1:
		var weaponPos = findWeaponAnchor("normal")
		var target = weaponPos.angle_to_point(currentFocusedBoss.position)
		firepot.global_rotation = target
		firepot.shot()
		BulletBase.generate(preload("res://components/Bullets/FireScan.tscn"), self, weaponPos, target)
	# elif type == 2:
	# 	var weaponPos = findWeaponAnchor("normal")
	# 	var target = weaponPos.angle_to_point(currentFocusedBoss.position)
	# 	firepot.global_rotation = target
	# 	firepot.shot()
		BulletBase.generate(preload("res://components/Bullets/Laser.tscn"), self, weaponPos, target)
