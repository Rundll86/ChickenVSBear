class_name ComponentManager

static var bullets = {}
static var characters = {}
static var effects = {}
static var feeds = []
static var uiComponents = {}
static var themes = {}
static var itemTextures = {}

static func init():
	for i in DirTool.listdir("res://components/Bullets"):
		bullets[DirTool.getBasenameWithoutExtension(i)] = load(i)
	for i in DirTool.listdir("res://components/Characters"):
		characters[DirTool.getBasenameWithoutExtension(i)] = load(i)
	for i in DirTool.listdir("res://components/Effects"):
		effects[DirTool.getBasenameWithoutExtension(i)] = load(i)
	for i in DirTool.listdir("res://components/Feeds"):
		feeds.append(load(i))
	for i in DirTool.listdir("res://components/UI"):
		uiComponents[DirTool.getBasenameWithoutExtension(i)] = load(i)
	for i in DirTool.listdir("res://themes"):
		themes[DirTool.getBasenameWithoutExtension(i)] = load(i)
	for i in DirTool.listdir("res://resources/items"):
		itemTextures[DirTool.getBasenameWithoutExtension(i)] = load("res://resources/items/%s" % i)
static func getBullet(name: String):
	return bullets[name]
static func getCharacter(name: String):
	return characters[name]
static func getEffect(name: String):
	return effects[name]
static func getFeed(index: int):
	return feeds[index]
static func getUIComponent(name: String):
	return uiComponents[name]
static func getTheme(name: String):
	return themes[name]
static func getItemTexture(name: String):
	return itemTextures[name]
static func readResource(path: String):
	return load("res://resources/%s" % path)
