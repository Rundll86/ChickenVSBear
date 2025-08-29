extends BulletBase
class_name PurpleCrystal

func ai():
	PresetAIs.forward(self, rotation)
func destroy(_beacuseMap: bool):
	EffectController.create(preload("res://components/Effects/PurpleCrystalExplosion.tscn"), global_position).shot()
