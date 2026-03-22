extends EntityBase
class_name Kernyr

func register():
	fields[FieldStore.Entity.MAX_HEALTH] = 2000
	fields[FieldStore.Entity.MOVEMENT_SPEED] = 0.1
	fields[FieldStore.Entity.OFFSET_SHOOT] = 20
	attackCooldownMap[0] = 300
func ai():
	PresetEntityAI.follow(self , currentFocusedBoss)
	tryAttack(0)
func attack(type: int):
	if type == 0:
		for bullet in BulletBase.generate(
			ComponentManager.getBullet("Yangyi"),
			self ,
			position,
			position.angle_to_point(currentFocusedBoss.position)
		):
			if bullet is YangyiBullet:
				pass
