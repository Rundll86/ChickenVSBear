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
static func getBullet(t: String) -> PackedScene:
	return MathTool.priority(bullets.get(t, false), load("res://components/Bullets/%s.tscn" % t))
static func getCharacter(t: String) -> PackedScene:
	return MathTool.priority(characters.get(t, false), load("res://components/Characters/%s.tscn" % t))
static func getEffect(t: String) -> PackedScene:
	return MathTool.priority(effects.get(t, false), load("res://components/Effects/%s.tscn" % t))
static func getFeed(i: int) -> PackedScene:
	if i >= 0 and i < feeds.size():
		return feeds[i]
	return null
static func getUIComponent(t: String) -> PackedScene:
	return MathTool.priority(uiComponents.get(t, false), load("res://components/UI/%s.tscn" % t))
static func getTheme(t: String) -> Theme:
	return MathTool.priority(themes.get(t, false), load("res://themes/%s.tscn" % t))
static func getItemTexture(t: String) -> Texture2D:
	return MathTool.priority(itemTextures.get(t, false), load("res://resources/items/%s.svg" % t))
