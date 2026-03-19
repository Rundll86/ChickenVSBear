extends BulletBase
class_name QKSwordBullet

var tracer: EntityBase
var attackedTracer: bool = false

func ai():
	if is_instance_valid(tracer) && !attackedTracer:
		look_at(tracer.getTrackingAnchor())
	if timeLived() > 1000:
		PresetBulletAI.forward(self , rotation) # 前进
		hitbox.disabled = false
	else:
		hitbox.disabled = true
func succeedToHit(_dmg: float, entity: EntityBase):
	if entity == tracer:
		attackedTracer = true # 只需要命中一次目标就不需要继续前进了
	EffectController.create(
		ComponentManager.getEffect("CatBoom"),
		entity.texture.global_position
	).shot()
