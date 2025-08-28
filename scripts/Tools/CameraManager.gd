@tool
extends Camera2D
class_name CameraManager

@export var shakeOffset: float = 100

@onready var animator: AnimationPlayer = $"%animator"

var shaking: bool = false

static var instance: CameraManager = null

func _ready():
	instance = self
func _physics_process(_delta):
	if is_instance_valid(UIState.player):
		position = UIState.player.position
		if shaking:
			position += MathTool.randv2_range(shakeOffset)

static func shake(millseconds: int = 1000):
	print("shake start")
	instance.shaking = true
	await TickTool.millseconds(millseconds)
	instance.shaking = false
	print("shake end")
static func playAnimation(animation: String):
	instance.animator.play(animation)
