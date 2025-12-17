extends BulletBase
class_name RedCrystalBullet

var radius: float = 0
var percent: float = 0
var count: int = 0

func register():
	hitbox.shape = hitbox.shape.duplicate()
func ai():
	PresetBulletAI.forward(self, rotation)
	speed = (1 - lifeTimePercent()) * initialSpeed
func destroy(_beacuseMap: bool):
	hitbox.shape.radius = radius
	EffectController.create(ComponentManager.getEffect("RedCrystalExplosion"), global_position).shot()
	for i in randi_range(1, count):
		for bullet in BulletBase.generate(ComponentManager.getBullet("CrystalBlock"), launcher, position, deg_to_rad(randf_range(0, 360))):
			if bullet is CrystalBlockBullet:
				bullet.baseDamage = baseDamage * percent
	await TickTool.millseconds(100)
