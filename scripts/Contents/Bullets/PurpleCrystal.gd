extends BulletBase

func ai():
	PresetBulletAI.forward(self, rotation)
func destroy(_beacuseMap: bool):
	var eff = EffectController.create(ComponentManager.getEffect("PurpleCrystalExplosion"), global_position)
	eff.rotation = rotation
	eff.shot()
