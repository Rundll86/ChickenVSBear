extends EntityBase
class_name KukeChild

var masterMine: KukeMC

func register():
	fields[FieldStore.Entity.MAX_HEALTH] = 30
	fields[FieldStore.Entity.MOVEMENT_SPEED] = 0.35
	attackCooldownMap[0] = 100
	attackCooldownMap[1] = 8000
func ai():
	PresetEntityAI.follow(self, currentFocusedBoss, 700)
	tryAttack(0)
	tryAttack(1)
	if timeLived() > 10000:
		tryKill()
func attack(type):
	if type == 0:
		BulletBase.generate(ComponentManager.getBullet("PurpleCrystalSmall"), self, findWeaponAnchor("normal"), position.angle_to_point(currentFocusedBoss.position))
		await TickTool.millseconds(randi_range(5, 25))
	elif type == 1:
		BulletBase.generate(ComponentManager.getBullet("HeavyCrystal"), self, findWeaponAnchor("normal"), position.angle_to_point(currentFocusedBoss.position))
func kill():
	if is_instance_valid(masterMine):
		masterMine.tryHeal(percentHealth(0.05))
