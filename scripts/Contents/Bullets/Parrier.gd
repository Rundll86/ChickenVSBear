extends BulletBase
class_name ParrierBullet

@export var parryRate: float = 1

func hitBullet(bullet: BulletBase):
	if BulletTool.canDamage(bullet, launcher):
		if MathTool.rate(parryRate):
			var eff = EffectController.create(ComponentManager.getEffect("Parry"), position + (bullet.position - position).normalized() * 150)
			eff.modulate = bullet.modulate.blend(bullet.texture.modulate)
			eff.shot()
			bullet.tryDestroy()
