extends BulletBase

var colors = [
	"#2BEAFF",
	"#FCA500",
	"#0042FF",
	"#D346D0",
	"#0C9B0B",
	"#FDEB0F"
]
var index = 0

@onready var heart = $"%heart"

func spawn():
	heart.modulate = Color(colors[index % colors.size()])
	rotation_degrees = 360.0 / colors.size() * index
func ai():
	rotation_degrees += 1.5
	heart.global_rotation_degrees = 0
	PresetBulletAI.lockLauncher(self, launcher, true)
func applyDot():
	BulletBase.generate(ComponentManager.getBullet("SoulBall"), launcher, heart.global_position, heart.global_position.angle_to_point(get_global_mouse_position()))
	await TickTool.millseconds(100)
	return true
