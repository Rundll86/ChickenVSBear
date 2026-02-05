extends BulletBase
class_name PipeBullet

var energy: float = 0

func ai():
	PresetBulletAI.forward(self, rotation)
	texture.rotation += energy * (1 - lifeTimePercent()) / 100
	speed = initialSpeed * (1 - lifeTimePercent())
