extends BulletBase
class_name QKSwordBullet

var tracer: EntityBase

func ai():
	if is_instance_valid(tracer):
		look_at(tracer.position)
	if timeLived() > 1000:
		PresetBulletAI.forward(self , rotation)
