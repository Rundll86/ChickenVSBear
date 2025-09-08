extends EntityBase
class_name KukeMC
func register():
	fields[FieldStore.Entity.MAX_HEALTH] = 1000
func ai():
	for bullet in get_tree().get_nodes_in_group("bullets"):
		if (
			bullet is LGBTBullet and
			bullet.position.distance_to(self.position) < 200
		):
			bullet.tryDestroy()
