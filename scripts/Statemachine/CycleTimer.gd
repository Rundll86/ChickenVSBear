class_name CycleTimer

@export var period: float = 1

var startTime: float = 0
var running: bool = false
var distance: float = 200
var bullets: Array[BulletBase] = []

func start():
	startTime = Time.get_ticks_msec()
	running = true
func lifetime():
	return Time.get_ticks_msec() - startTime
func getStateAngle(index: int):
	return lifetime() / period * deg_to_rad(360) - deg_to_rad(360.0 * index / len(bullets))
func apply():
	bullets = bullets.filter(is_instance_valid)
	for index in len(bullets):
		var bullet = bullets[index]
		var newStateAngle = lerp_angle(bullet.cycleStateAngle, getStateAngle(index), 0.1)
		var offset = Vector2.from_angle(newStateAngle)
		bullet.cycleStateAngle = newStateAngle
		offset.y *= 0.25
		bullet.position = bullet.launcher.position + offset * distance
		bullet.scale = Vector2.ONE * (1 + offset.y)
func host(bullet: BulletBase):
	bullets.append(bullet)
