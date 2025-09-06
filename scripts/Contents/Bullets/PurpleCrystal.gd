extends BulletBase
class_name PurpleCrystal

func ai():
	PresetAIs.forward(self, rotation)
func destroy(_beacuseMap: bool):
	EffectController.create(preload("res://components/Effects/PurpleCrystalExplosion.tscn"), global_position).shot()
func split(index, total, _last):
	BulletBase.generate(
		preload("res://components/Bullets/PurpleCrystal.tscn"),
		launcher,
		position,
		rotation + deg_to_rad(360 / total * index),
		true,
		isChildRefract
	)
func refract(entity, _index, _total, _last):
	BulletBase.generate(
		preload("res://components/Bullets/PurpleCrystal.tscn"),
		launcher,
		position,
		position.angle_to_point(entity.position) if is_instance_valid(entity) else randf_range(0, deg_to_rad(360)),
		isChildSplit,
		true
	)
