class_name CooldownTimer

var cooldown: float = 100
var lastStart: int = 0
var speedScale: float = 1

func _init(cd: float = 100):
	cooldown = cd

func centralTime():
	return cooldown / speedScale
func isCooldowned():
	return timeSinceLastStart() >= centralTime()
func start():
	var state = isCooldowned()
	if state:
		lastStart = WorldManager.getTime()
	return state
func timeSinceLastStart():
	return WorldManager.getTime() - lastStart
