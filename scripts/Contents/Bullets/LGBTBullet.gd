extends BulletBase
class_name LGBTBullet

var myTracer: EntityBase = null

func spawn():
	findTracer()
func register():
	speed = 1
	damage = 5
func ai():
	texture.rotation_degrees += speed
	speed *= 1.05
	speed = clamp(speed, 0, 20)
	if is_instance_valid(myTracer):
		PresetAIs.trace(self, myTracer.position, clamp(speed / 150, 0, 1))
	else:
		findTracer()
	PresetAIs.forward(self, rotation)
func findTracer():
	myTracer = EntityTool.findClosetEntity(position, get_tree(), false, true)
