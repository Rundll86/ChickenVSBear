extends BulletBase
class_name ChickSprint

func register():
	speed = 0
	penerate = 1
func ai():
	damage = launcher.velocity.length() / 500
	PresetBulletAI.lockLauncher(self, launcher, true)
	if !launcher.sprinting:
		tryDestroy()
func destroy(beacuseMap: bool):
	if beacuseMap:
		launcher.bulletHit(self, MathTool.rate(0.5))
