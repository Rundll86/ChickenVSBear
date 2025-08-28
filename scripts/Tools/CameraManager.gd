@tool
extends Camera2D
class_name CameraManager

@onready var animator: AnimationPlayer = $"%animator"

var shakeIntensity: float = 0

static var instance: CameraManager = null

func _ready():
	instance = self
func _physics_process(_delta):
	if is_instance_valid(UIState.player):
		position = UIState.player.position
		position += MathTool.randv2_range(shakeIntensity)

static func shake(millseconds: int, intensity: float = 10):
	instance.shakeIntensity += intensity
	await TickTool.millseconds(millseconds)
	instance.shakeIntensity -= intensity
static func playAnimation(animation: String):
	instance.animator.play(animation)
