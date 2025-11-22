extends BulletBase
class_name ChickSprint

var atk: float = 1

func register():
	speed = 0
	penerate = 1
func ai():
	baseDamage = launcher.velocity.length() / 500 * atk
	PresetBulletAI.lockLauncher(self, launcher, true)
	if !launcher.sprinting:
		tryDestroy()
func destroy(beacuseMap: bool):
	if beacuseMap:
		launcher.bulletHit(self, MathTool.rate(0.5))
