extends BulletBase
class_name PurpleCrystal

func ai():
	PresetsAI.forward(self, rotation)
func destroy():
	EffectController.create(preload("res://components/Effects/PurpleCrystalExplosion.tscn"), global_position).shot()
