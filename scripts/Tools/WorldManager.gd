extends Node2D
class_name WorldManager

static var rootNode: Node2D
static var tree: SceneTree
static var runningTime: float = 0

func _ready():
	tree = get_tree()
	rootNode = self
func _physics_process(delta):
	runningTime += delta
	if EntityBase.mobCount() == 0:
		UIState.setPanel("MakeFeed")

static func getTime():
	return runningTime
