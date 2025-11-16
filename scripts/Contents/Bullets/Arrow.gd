extends BulletBase
class_name Arrow

var atk: float = 0

func ai():
	speed = (1 - lifeDistancePercent()) * initialSpeed
	damage = speed * atk
	PresetBulletAI.forward(self, rotation)
	if speed < 1:
		tryDestroy()
