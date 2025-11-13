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
	if EntityBase.mobCount() == 0 and runningTime > 1000:
		UIState.setPanel("MakeFeed")

@rpc("authority")
func nextWave(waves: Array[Wave]):
	Wave.next(waves)

func spawnWave():
	var waves = Wave.spawn()
	nextWave(waves)
	if MultiplayerState.isMultiplayer and multiplayer.is_server():
		nextWave.rpc(waves)

static func getTime():
	return runningTime
