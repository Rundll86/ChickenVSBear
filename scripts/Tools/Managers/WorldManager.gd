extends Node2D
class_name WorldManager

static var rootNode: WorldManager
static var tree: SceneTree
static var runningTime: int = 0
static var peer: ENetMultiplayerPeer

func _ready():
	tree = get_tree()
	rootNode = self
	ComponentManager.init()
func _physics_process(delta):
	runningTime += delta * 1000
	if multiplayer.is_server() or not MultiplayerState.isMultiplayer:
		if EntityBase.mobCount() == 0 and runningTime > 3000:
			Wave.next()
			UIState.setPanel("MakeFeed")

static func getTime():
	return runningTime
