extends BulletBase
class_name NeedleBullet

var forwarding: bool = false

func spawn():
	hitbox.disabled = true
func ai():
	PresetBulletAI.forward(self , rotation)
	if forwarding:
		speed += 0.5
	else:
		speed -= 0.25
		if speed <= 0:
			forwarding = true
			hitbox.disabled = false
func succeedToHit(_dmg: float, entity: EntityBase):
	var effect = EffectController.create(ComponentManager.getEffect("Dustdown"), entity.position)
	effect.rotation = rotation
	effect.shot()
	rotation = Vector2.from_angle(rotation).bounce((entity.position - position).normalized()).angle()
