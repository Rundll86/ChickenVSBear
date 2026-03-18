extends BulletBase
class_name QKSwordHandler

func succeedToHit(_dmg: float, entity: EntityBase):
	for bullet in BulletBase.generate(
		ComponentManager.getBullet("QKSword"),
		launcher,
		entity.position,
		0
	):
		if bullet is QKSwordBullet:
			bullet.position = entity.texture.global_position + MathTool.sampleInRing(50, 200)
			bullet.tracer = entity
			bullet.look_at(entity.position)
