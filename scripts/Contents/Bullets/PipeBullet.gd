extends BulletBase
class_name PipeBullet

var energy: float = 0

func ai():
	PresetBulletAI.forward(self, rotation)
	texture.rotation += initialSpeed * (1 - lifeTimePercent()) / 100
	speed = initialSpeed * (1 - lifeTimePercent())
	baseDamage = energy
func destroy(_beacuseMap: bool):
	EffectController.create(ComponentManager.getEffect("PipeFall"), position).shot()
func succeedToHit(_dmg: float, _entity: EntityBase):
	energy *= 0.6
