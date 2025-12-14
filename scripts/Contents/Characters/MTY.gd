extends EntityBase
class_name MTY

func register():
	fields[FieldStore.Entity.MAX_HEALTH] = 400
	fields[FieldStore.Entity.MOVEMENT_SPEED] = 0.9
	attackCooldownMap[0] = 1500
	attackCooldownMap[1] = 500
	sprintMultiplier = 5
func ai():
	PresetEntityAI.follow(self, currentFocusedBoss)
	tryAttack(0)
	tryAttack(1)
func attack(type: int):
	if type == 0:
		trySprint()
	elif type == 1:
		BulletBase.generate(ComponentManager.getBullet("MTYSprint"), self, position, 0)
	return true
func sprint():
	var target = BulletTool.findClosetBulletCanDamage(position, get_tree(), self)
	if is_instance_valid(target):
		var dir = (target.position - position).rotated(MathTool.randomChoiceFrom([-1, 1]) * deg_to_rad(90))
		move(dir.normalized() * sprintMultiplier, true)
