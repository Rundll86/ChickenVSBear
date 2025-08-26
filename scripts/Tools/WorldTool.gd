extends Node2D
class_name WorldManager

static var rootNode: Node2D
static var tree: SceneTree

func _ready():
	tree = get_tree()
	rootNode = self
	Wave.next()
