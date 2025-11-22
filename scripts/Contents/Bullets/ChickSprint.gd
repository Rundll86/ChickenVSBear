extends BulletBase
class_name ChickSprint

func register():
	speed = 0
	penerate = 1
func ai():
	baseDamage = launcher.velocity.length() / 500.0
	PresetBulletAI.lockLauncher(self, launcher, true)
	if !launcher.sprinting:
		tryDestroy()
func destroy(beacuseMap: bool):
	if beacuseMap:
		launcher.bulletHit(self, MathTool.rate(0.5))
