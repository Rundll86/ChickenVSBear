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
			var cycler = launcher.getOrCreateCycleTimer("parry", 2000, 100)
			if len(cycler.bullets) < 5:
				for b in BulletBase.generate(
					ComponentManager.getBullet("ParryBall"),
					launcher,
					position,
					0
				):
					if b is ParryBallBullet:
						pass
