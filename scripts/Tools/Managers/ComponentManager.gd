@tool
extends Node
class_name ComponentManager

static var bullets = {}
static var characters = {}
static var weapons = {}
static var summons = {}
static var effects = {}
static var feeds = []
static var obstacles = {}
static var panels = {}
static var uiComponents = {}
static var themes = {}
static var fieldTextures = {}
static var itemTextures = {}

static func init():
	for i in DirTool.listdir("res://components/Bullets"):
		bullets[DirTool.getBasenameWithoutExtension(i)] = load(i)
	for i in DirTool.listdir("res://components/Characters"):
		characters[DirTool.getBasenameWithoutExtension(i)] = load(i)
	for i in DirTool.listdir("res://components/Weapons"):
		weapons[DirTool.getBasenameWithoutExtension(i)] = load(i)
	for i in DirTool.listdir("res://components/Summons"):
		summons[DirTool.getBasenameWithoutExtension(i)] = load(i)
	for i in DirTool.listdir("res://components/Effects"):
		effects[DirTool.getBasenameWithoutExtension(i)] = load(i)
	for i in DirTool.listdir("res://components/Feeds"):
		feeds.append(load(i))
	for i in DirTool.listdir("res://components/Obstacles"):
		obstacles[DirTool.getBasenameWithoutExtension(i)] = load(i)
	for i in DirTool.listdir("res://components/Scenes/FullscreenPanels"):
		panels[DirTool.getBasenameWithoutExtension(i)] = load(i)
	for i in DirTool.listdir("res://components/UI"):
		uiComponents[DirTool.getBasenameWithoutExtension(i)] = load(i)
	for i in DirTool.listdir("res://themes"):
		themes[DirTool.getBasenameWithoutExtension(i)] = load(i)
	for i in DirTool.listdir("res://resources/fieldIcons"):
		fieldTextures[DirTool.getBasenameWithoutExtension(i)] = load(i)
	for i in DirTool.listdir("res://resources/items"):
		itemTextures[DirTool.getBasenameWithoutExtension(i)] = load(i)
static func getBullet(t: String) -> PackedScene:
	return MathTool.priority(bullets.get(t, false), load("res://components/Bullets/%s.tscn" % t))
static func getCharacter(t: String) -> PackedScene:
	return MathTool.priority(characters.get(t, false), load("res://components/Characters/%s.tscn" % t))
static func getWeapon(t: String) -> PackedScene:
	return MathTool.priority(weapons.get(t, false), load("res://components/Weapons/%s.tscn" % t))
static func getSummon(t: String) -> PackedScene:
	return MathTool.priority(summons.get(t, false), load("res://components/Summons/%s.tscn" % t))
static func getEffect(t: String) -> PackedScene:
	return MathTool.priority(effects.get(t, false), load("res://components/Effects/%s.tscn" % t))
static func getFeed(i: int) -> PackedScene:
	if i >= 0 and i < feeds.size():
		return feeds[i]
	return null
static func getObstacle(t: String) -> PackedScene:
	return MathTool.priority(obstacles.get(t, false), load("res://components/Obstacles/%s.tscn" % t))
static func getPanel(t: String) -> PackedScene:
	return MathTool.priority(panels.get(t, false), load("res://components/Scenes/FullscreenPanels/%s.tscn" % t))
static func getUIComponent(t: String) -> PackedScene:
	return MathTool.priority(uiComponents.get(t, false), load("res://components/UI/%s.tscn" % t))
static func getTheme(t: String) -> Theme:
	return MathTool.priority(themes.get(t, false), load("res://themes/%s.tres" % t))
static func getFieldTexture(t: String) -> Texture2D:
	return MathTool.priority(fieldTextures.get(t, false), load("res://resources/fieldIcons/%s.svg" % t))
static func getItemTexture(t: String) -> Texture2D:
	return MathTool.priority(itemTextures.get(t, false), load("res://resources/items/%s.svg" % t))
