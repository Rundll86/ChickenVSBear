class_name CooldownTimer

var cooldown: float = 100
var lastStart: int = 0

func isCooldowned():
	return timeSinceLastStart() >= cooldown
func start():
	var state = isCooldowned()
	if state:
		lastStart = WorldManager.getTime()
	return state
func timeSinceLastStart():
	return WorldManager.getTime() - lastStart
