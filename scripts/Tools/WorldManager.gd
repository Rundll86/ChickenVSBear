extends Node2D
class_name WorldManager

static var rootNode: Node2D
static var tree: SceneTree

func _ready():
	tree = get_tree()
	rootNode = self
func _physics_process(_delta):
	if EntityBase.mobCount() == 0:
		UIState.setPanel("MakeFeed")
