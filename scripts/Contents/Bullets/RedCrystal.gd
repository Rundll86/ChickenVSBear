extends BulletBase
class_name RedCrystalBullet

var radius: float = 0

func register():
	hitbox.shape = hitbox.shape.duplicate()
func ai():
	PresetBulletAI.forward(self, rotation)
	speed = (1 - lifeTimePercent()) * initialSpeed
func destroy(_beacuseMap: bool):
	hitbox.shape.radius = radius
	EffectController.create(ComponentManager.getEffect("RedCrystalExplosion"), global_position).shot()
	await TickTool.millseconds(100)
