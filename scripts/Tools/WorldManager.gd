extends Node2D
class_name WorldManager

static var rootNode: Node2D
static var tree: SceneTree
static var runningTime: int = 0

func _ready():
	tree = get_tree()
	rootNode = self
func _physics_process(delta):
	runningTime += delta * 1000
	if EntityBase.mobCount() == 0 and runningTime > 3000:
		UIState.setPanel("MakeFeed")

static func getTime():
	return runningTime
