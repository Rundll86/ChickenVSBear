extends BulletBase
class_name ParrierBullet

func hitBullet(bullet: BulletBase):
	if BulletTool.canDamage(bullet, launcher):
		var eff = EffectController.create(ComponentManager.getEffect("Parry"), position)
		eff.modulate = bullet.modulate
		eff.shot()
		bullet.tryDestroy()
		tryDestroy()
