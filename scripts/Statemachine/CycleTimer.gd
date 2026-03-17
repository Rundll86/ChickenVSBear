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
func periodPercent(count: int):
	return lifetime() / period * deg_to_rad(360) - deg_to_rad(360.0 * count / len(bullets))
func apply():
	bullets = bullets.filter(is_instance_valid)
	for index in len(bullets):
		var bullet = bullets[index]
		var offset = Vector2.from_angle(periodPercent(index))
		offset.y *= 0.5
		bullet.position = bullet.launcher.position + offset * distance
		bullet.scale = Vector2.ONE * (1 + offset.y)
func host(bullet: BulletBase):
	bullets.append(bullet)
