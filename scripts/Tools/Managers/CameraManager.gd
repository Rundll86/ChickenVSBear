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

static func shake(millseconds: float, intensity: float = 10, steper: Callable = func(currentValue, _totalValue, _restPercent): return currentValue):
	var startTime = WorldManager.getTime()
	instance.shakeIntensity = intensity
	await TickTool.until(
		func():
			instance.shakeIntensity = steper.call(instance.shakeIntensity, intensity, 1 - (WorldManager.getTime() - startTime) / millseconds)
			return WorldManager.getTime() - startTime >= millseconds
	)
	instance.shakeIntensity = 0
static func playAnimation(animation: String):
	instance.animator.play(animation)
