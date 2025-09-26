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
var generationDuration: float = 15000
var pingAfterGeneration: float = 5000

@onready var heart = $"%heart"
@onready var effect: GPUParticles2D = $"%effect"

func register():
	area_entered.connect(
		func(area):
			var bullet = BulletTool.fromArea(area)
			if bullet and BulletTool.canDamage(bullet, launcher):
				launcher.tryHeal(1)
				launcher.storeEnergy(damage * 0.25)
	)
func spawn():
	modulate = Color(colors[index % colors.size()])
	effect.emitting = true
	launcher.tryHeal(5)
	
func ai():
	rotation_degrees = 360.0 / colors.size() * index + timeLived() / generationDuration * 360 - index / 6.0 * 360.0
	heart.global_rotation_degrees = 0
	PresetBulletAI.lockLauncher(self, launcher, true)
func applyDot():
	if timeLived() > generationDuration * ((6.0 - index) / 6.0) + pingAfterGeneration:
		BulletBase.generate(ComponentManager.getBullet("SoulBall"), launcher, heart.global_position, heart.global_position.angle_to_point(get_global_mouse_position()))
	await TickTool.millseconds(100)
	return true
