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
var spawnedChild = false

@onready var heart = $"%heart"
@onready var effect: GPUParticles2D = $"%effect"

func spawn():
	modulate = Color(colors[index % colors.size()])
	effect.emitting = true
	
func ai():
	rotation_degrees = 360.0 / colors.size() * index + timeLived() / 20000.0 * 360 - index / 6.0 * 360.0
	heart.global_rotation_degrees = 0
	PresetBulletAI.lockLauncher(self, launcher, true)
func applyDot():
	if timeLived() > 20000 * ((6.0 - index) / 6.0):
		if !spawnedChild:
			spawnedChild = true
			var count = 7
			for i in count:
				BulletBase.generate(ComponentManager.getBullet("WhiteSoul"), launcher, heart.global_position, rotation + deg_to_rad(360.0 / count * i))
				await TickTool.millseconds(50)
		BulletBase.generate(ComponentManager.getBullet("SoulBall"), launcher, heart.global_position, heart.global_position.angle_to_point(get_global_mouse_position()))
	await TickTool.millseconds(100)
	return true
