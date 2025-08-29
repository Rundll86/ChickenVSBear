class_name TickTool

static func millseconds(ms: int):
	return await WorldManager.tree.create_timer(ms / 1000.0).timeout
static func frame(count: int = 1):
	for i in range(count):
		await WorldManager.tree.physics_frame
static func until(predicate: Callable):
	while not predicate.call():
		await frame()
