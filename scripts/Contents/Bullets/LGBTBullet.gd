extends BulletBase
class_name LGBTBullet

var tracer: EntityBase = null
var maxTraceTime: float = 0
var tracePower: float = 0
var lastDistance: float = INF
var missedTarget: bool = false

func register():
	speed = 1
func ai():
	speed *= 1.05
	speed = clamp(speed, 0, 20)
	if !missedTarget and is_instance_valid(tracer) and timeLived() < maxTraceTime:
		PresetBulletAI.trace(self, tracer.getTrackingAnchor(), tracePower)
	PresetBulletAI.forward(self, rotation)
	var currentDistance = position.distance_to(tracer.getTrackingAnchor())
	if currentDistance > lastDistance:
		missedTarget = true
	else:
		lastDistance = currentDistance
func destroy(_b):
	EffectController.create(ComponentManager.getEffect("LGBTBoom"), position).shot()
