class_name EntityTool

static func fromHurtbox(node: Node) -> EntityBase:
	if node is Area2D:
		var texture = node.get_parent()
		if texture is AnimatedSprite2D:
			var entity = texture.get_parent()
			if entity is EntityBase:
				return entity as EntityBase
	return null
static func findClosetEntity(to: Vector2, fromTree: SceneTree, player: bool = false, mob: bool = false, excludes: Array = [], allowSummon: bool = false) -> EntityBase:
	var result = null
	var lastDistance = INF
	var nodes = []
	if player:
		nodes += fromTree.get_nodes_in_group("players")
	if mob:
		nodes += fromTree.get_nodes_in_group("mobs")
	for entity in nodes:
		if entity is EntityBase and entity not in excludes:
			if !allowSummon:
				if entity.isSummon():
					continue
			if to.distance_to(entity.position) < lastDistance:
				lastDistance = to.distance_to(entity.position)
				result = entity
	return result
static func findClosetPlayer(to: Vector2, fromTree: SceneTree, excludes: Array[EntityBase] = [], allowSummon: bool = false) -> EntityBase:
	return findClosetEntity(to, fromTree, true, false, excludes, allowSummon)
static func findEntityByClass(cls: String, fromTree: SceneTree) -> Array[EntityBase]:
	var results: Array[EntityBase] = []
	var nodes = fromTree.get_nodes_in_group("mobs") + fromTree.get_nodes_in_group("players")
	for entity in nodes:
		if entity.get_class() == cls:
			results.append(entity)
	return results
