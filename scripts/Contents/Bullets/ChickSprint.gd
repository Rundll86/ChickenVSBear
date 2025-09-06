extends BulletBase
class_name ChickSprint

func register():
	speed = 0
	damage = 20
	penerate = 1
func ai():
	PresetBulletAI.lockLauncher(self, launcher, true)
	if !launcher.sprinting:
		tryDestroy()
func destroy(beacuseMap: bool):
	if beacuseMap:
		launcher.takeDamage(self, 0.5)
