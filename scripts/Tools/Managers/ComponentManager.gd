class_name ComponentManager

static var bullets = {}
static var characters = {}
static var effects = {}

static func init():
	for i in DirTool.listdir("res://components/Bullets"):
		bullets[DirTool.getBasenameWithoutExtension(i)] = load(i)
	for i in DirTool.listdir("res://components/Characters"):
		characters[DirTool.getBasenameWithoutExtension(i)] = load(i)
	for i in DirTool.listdir("res://components/Effects"):
		effects[DirTool.getBasenameWithoutExtension(i)] = load(i)
static func getBullet(name: String):
	return bullets[name]
static func getCharacter(name: String):
	return characters[name]
static func getEffect(name: String):
	return effects[name]
