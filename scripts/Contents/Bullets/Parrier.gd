extends BulletBase
class_name ParrierBullet

@export var parryRate: float = 1

func hitBullet(bullet: BulletBase): # 当前子弹与其他子弹相撞
	if BulletTool.canDamage(bullet, launcher): # 其他子弹可以使当前子弹的发射者受伤吗？
		if MathTool.rate(parryRate):
			# 生成格挡特效
			var eff = EffectController.create(ComponentManager.getEffect("Parry"), position + (bullet.position - position).normalized() * 150) # 从子弹位置，面向其他子弹的方向前进150
			eff.modulate = bullet.modulate.blend(bullet.texture.modulate)
			eff.shot()
			# 摧毁其他子弹
			bullet.tryDestroy()
			var cycler = launcher.getOrCreateCycleTimer("parry", 2000, 100)
			if len(cycler.bullets) < 5: # 玩家最多只能拥有5点气
				for b in BulletBase.generate(
					ComponentManager.getBullet("ParryBall"), # 生成气的子弹
					launcher,
					position,
					0
				):
					if b is ParryBallBullet:
						pass
