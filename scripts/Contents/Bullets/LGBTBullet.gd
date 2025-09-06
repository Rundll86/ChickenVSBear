extends BulletBase
class_name LGBTBullet

var tracer: EntityBase = null
var maxTraceTime: float = 0
var tracePower: float

func register():
	speed = 1
func ai():
	speed *= 1.05
	speed = clamp(speed, 0, 20)
	if is_instance_valid(tracer) and timeLived() < maxTraceTime:
		PresetBulletAI.trace(self, tracer.getTrackingAnchor(), clamp(speed / 50 * tracePower, 0, 1))
	PresetBulletAI.forward(self, rotation)
func destroy(_b):
	EffectController.create(preload("res://components/Effects/LGBTBoom.tscn"), position).shot()
