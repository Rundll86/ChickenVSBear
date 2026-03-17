extends BulletBase
class_name ParryBallBullet

var cycler: CycleTimer

func spawn():
	cycler = launcher.getOrCreateCycleTimer("parry")
	cycler.host(self )
func ai():
	PresetBulletAI.selfRotate(self , 5)
	hitbox.disabled = !launcher.sprinting
