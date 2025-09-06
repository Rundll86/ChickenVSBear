extends BulletBase
class_name VectorStar

var tracer: EntityBase = null
var forwardTime: float = 1000
var forwarded: bool = false
var rotateSpeed: float = 1

func ai():
	texture.rotation_degrees += rotateSpeed
	rotateSpeed += 0.25
	PresetBulletAI.forward(self, rotation)
	if timeLived() <= forwardTime:
		speed = 10 * ((forwardTime - timeLived()) / forwardTime)
	elif forwarded:
		speed = (timeLived() - forwardTime) / 30
	else:
		forwarded = true
		if is_instance_valid(tracer):
			rotation = position.angle_to_point(tracer.getTrackingAnchor())
