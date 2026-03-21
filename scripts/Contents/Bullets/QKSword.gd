extends BulletBase
class_name QKSwordBullet

var tracer: EntityBase
var attackedTracer: bool = false
var spawnSpeed: float = 1

func register():
	spawnSpeed = randf_range(0.25, 1.75)
	animator.speed_scale = spawnSpeed
func ai():
	if is_instance_valid(tracer) && !attackedTracer:
		look_at(tracer.getTrackingAnchor())
	if timeLived() > 1000 / spawnSpeed:
		PresetBulletAI.forward(self , rotation) # 前进
		hitbox.disabled = false
	else:
		hitbox.disabled = true
func succeedToHit(_dmg: float, entity: EntityBase):
	if entity == tracer:
		attackedTracer = true # 只需要命中一次目标就不需要继续前进了
	EffectController.create(
		ComponentManager.getEffect("FooExplosion"),
		entity.texture.global_position
	).shot()
