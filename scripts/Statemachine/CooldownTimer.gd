class_name CooldownTimer

var cooldown: float = 100
var lastStart: int = 0

func isCooldowned():
	return WorldManager.getTime() - lastStart >= cooldown
func start():
	var state = isCooldowned()
	if state:
		lastStart = WorldManager.getTime()
	return state
