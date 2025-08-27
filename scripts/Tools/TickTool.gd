class_name TickTool

static func millseconds(ms: int):
	return await WorldManager.tree.create_timer(ms / 1000.0).timeout