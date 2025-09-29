@tool
extends Weapon

func update(to, origin, _entity):
	origin["atk"] += 2 * to * soulLevel
	origin["count"] += 0.2 * to * soulLevel
	origin["radius"] /= 1 + 0.05 * to * soulLevel
	return origin
func attack(entity: EntityBase):
	for i in readStore("count"):
		var myPos = get_global_mouse_position() + QuickUI.getWindowSize() * Vector2(randf_range(-1, 1) * 0.25, -1)
		for j in BulletBase.generate(ComponentManager.getBullet("WhiteSoul"), entity,
			myPos,
			myPos.angle_to_point(get_global_mouse_position() + MathTool.randv2_range(readStore("radius")))
		):
			j.damage = readStore("atk")
	return true
