extends Node2D
class_name WorldManager

static var rootNode: WorldManager
static var tree: SceneTree
static var runningTime: int = 0
static var peer: ENetMultiplayerPeer
static var spawner: MultiplayerSpawner

func _ready():
	tree = get_tree()
	rootNode = self
	spawner = $%spawner
	ComponentManager.init()
	spawner.spawn_function = justReturn
func _physics_process(delta):
	runningTime += delta * 1000
	if EntityBase.mobCount() == 0 and runningTime > 1000:
		UIState.setPanel("MakeFeed")

@rpc("authority")
func nextWave(waves: Array):
	Wave.next(waves)

func spawnWave():
	var waves = Wave.spawn()
	nextWave(waves)
	if MultiplayerState.isMultiplayer and multiplayer.is_server():
		nextWave.rpc(waves)
func spawn(node: Node):
	if MultiplayerState.isMultiplayer:
		if multiplayer.is_server():
			spawner.spawn([node])
	else:
		add_child(node)
func justReturn(data):
	print(ArrayTool.parseEncodedObject(data))
	return ArrayTool.parseEncodedObject(data)[0]

static func getTime():
	return runningTime
static func spawnNode(node: Node):
	rootNode.spawn(node)
