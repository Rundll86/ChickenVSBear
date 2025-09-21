@tool
extends Node
class_name ComponentManager

static var bullets = {}
static var characters = {}
static var effects = {}
static var feeds = []
static var uiComponents = {}
static var themes = {}
static var itemTextures = {}

func _ready():
	init()

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
		itemTextures[DirTool.getBasenameWithoutExtension(i)] = load(i)
static func getBullet(t: String):
	return bullets[t]
static func getCharacter(t: String):
	return characters[t]
static func getEffect(t: String):
	return effects[t]
static func getFeed(i: int):
	return feeds[i]
static func getUIComponent(t: String):
	return uiComponents[t]
static func getTheme(t: String):
	return themes[t]
static func getItemTexture(t: String):
	return itemTextures[t]
