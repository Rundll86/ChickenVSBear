class_name EntityTool

static func fromHurtbox(node: Node) -> EntityBase:
	if node is Area2D:
		var texture = node.get_parent()
		if texture is AnimatedSprite2D:
			var entity = texture.get_parent()
			if entity is EntityBase:
				return entity as EntityBase
	return null