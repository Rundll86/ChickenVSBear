extends Node2D
class_name WorldTool

static var rootNode: Node2D
static var tree: SceneTree

func _ready():
	tree = get_tree()
	rootNode = self
