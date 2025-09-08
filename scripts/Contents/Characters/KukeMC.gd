extends EntityBase
class_name KukeMC
func ai():
	for bullet in get_tree().get_nodes_in_group("bullet"):
		if (
			bullet is LGBTBullet and
			bullet.position.distance_to(self.position) < 100
		):
			bullet.tryDestroy()
	for entity in get_tree().get_nodes_in_group("bosses"):
		if (
			entity.name == "FurryR" and
			entity.position.distance_to(self.position) < 100
		):
			entity.takeDamage(114514)