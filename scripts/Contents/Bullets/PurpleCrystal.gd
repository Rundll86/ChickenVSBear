extends BulletBase

func ai():
	PresetBulletAI.forward(self, rotation)
func destroy(_beacuseMap: bool):
	var eff = EffectController.create(ComponentManager.getEffect("PurpleCrystalExplosion"), global_position)
	eff.rotation = rotation
	eff.shot()
func split(index, total, _last):
	BulletBase.generate(
		ComponentManager.getBullet("PurpleCrystal"),
		launcher,
		position,
		rotation + deg_to_rad(360 / total * index),
		true,
		isChildRefract
	)
func refract(entity, _index, _total, _last):
	BulletBase.generate(
		ComponentManager.getBullet("PurpleCrystal"),
		launcher,
		position,
		position.angle_to_point(entity.position) if is_instance_valid(entity) else randf_range(0, deg_to_rad(360)),
		isChildSplit,
		true
	)
