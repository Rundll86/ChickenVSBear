extends BulletBase
class_name BlueCrystalBullet

var tracer: EntityBase = null
@onready var trail: GPUParticles2D = $%trail

func ai():
	if is_instance_valid(tracer):
		var tracker = tracer.getTrackingAnchor()
		var targetAngle = position.angle_to_point(tracker)
		trail.rotation = - Vector2.from_angle(rotation).angle_to(Vector2.from_angle(targetAngle)) * 0.75 / (speed / initialSpeed)
		PresetBulletAI.trace(self, tracker, 0.05)
	else:
		trail.rotation = 0
	speed += 0.1
	PresetBulletAI.forward(self, rotation)
