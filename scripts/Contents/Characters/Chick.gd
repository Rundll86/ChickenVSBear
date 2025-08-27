extends EntityBase
class_name Chick

@onready var firepot = $"%firepot"

const laserCount = 4

func _ready():
	fields[FieldStore.Entity.MAX_HEALTH] = 2000
	fields[FieldStore.Entity.MOVEMENT_SPEED] = 0.1
	super._ready()

func ai():
	move(currentFocusedBoss.position - position)
	if currentFocusedBoss.position.distance_to(position) < 200:
		tryAttack(2)
	elif currentFocusedBoss.position.distance_to(position) < 400:
		tryAttack(1)
	else:
		tryAttack(0)
func attack(type):
	if type == 0:
		var weaponPos = findWeaponAnchor("normal")
		for i in randi_range(10, 20):
			BulletBase.generate(preload("res://components/Bullets/Diamond.tscn"), self, weaponPos + MathTool.randv2_range(20), rotation + deg_to_rad(randf_range(-90, 90)))
	elif type == 1:
		for i in range(laserCount):
			BulletBase.generate(preload("res://components/Bullets/Laser.tscn"), self, texture.global_position, deg_to_rad(90 * i))
	elif type == 2:
		var weaponPos = findWeaponAnchor("normal")
		var target = weaponPos.angle_to_point(currentFocusedBoss.position)
		firepot.global_rotation = target
		firepot.shot()
		BulletBase.generate(preload("res://components/Bullets/FireScan.tscn"), self, weaponPos, target)
	return true
