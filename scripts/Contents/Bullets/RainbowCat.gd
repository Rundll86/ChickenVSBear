extends BulletBase
class_name RainbowCat

func register():
	penerate = 1
func ai():
	PresetBulletAI.forward(self, rotation)
func succeedToHit(_dmg: float, _entity: EntityBase):
	EffectController.create(ComponentManager.getEffect("CatBoom"), position).shot()
	rotation_degrees = randf_range(0, 360)
