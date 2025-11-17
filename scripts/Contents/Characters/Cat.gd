extends EntityBase
class_name Maodie

func register():
	fields[FieldStore.Entity.MAX_HEALTH] = 75
	fields[FieldStore.Entity.MOVEMENT_SPEED] = randf_range(0.5, 0.8)
	attackCooldownMap[0] = randi_range(2500, 6000)
	sprintMultiplier = randf_range(10, 35)
func ai():
	PresetEntityAI.follow(self, currentFocusedBoss)
	tryAttack(0, true)
func attack(type: int):
	if type == 0:
		for bullet in BulletBase.generate(ComponentManager.getBullet("ChickSprint"), self, position, 0):
			if bullet is ChickSprint:
				bullet.atk = 0.2
		trySprint()
	return true
func sprint():
	move((currentFocusedBoss.position - position).normalized() * sprintMultiplier, true)
