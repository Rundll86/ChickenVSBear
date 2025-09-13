class_name CooldownTimer

var cooldown: float = 100
var lastStart: int = 0

func _init(cd: float = 100):
	cooldown = cd

func isCooldowned():
	return timeSinceLastStart() >= cooldown
func start():
	var state = isCooldowned()
	if state:
		lastStart = WorldManager.getTime()
	return state
func timeSinceLastStart():
	return WorldManager.getTime() - lastStart
