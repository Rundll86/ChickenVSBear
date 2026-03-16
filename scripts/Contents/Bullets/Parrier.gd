extends BulletBase
class_name ParrierBullet

func hitBullet(bullet: BulletBase):
	if BulletTool.canDamage(bullet, launcher):
		EffectController.create(ComponentManager.getEffect("Parry"), position).shot()
		bullet.tryDestroy()
		tryDestroy()
func ai():
	PresetBulletAI.forward(self , rotation)
