@tool
extends Camera2D
class_name CameraManager

static var camera: Camera2D = null

func _ready():
	camera = self
func _physics_process(_delta):
	if is_instance_valid(UIState.player):
		position = UIState.player.position
