extends BulletBase
class_name SevenSoulBullet

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
var energyCollect: float = 0
var healAmount: float = 0

@onready var heart = $"%heart"
@onready var effect: GPUParticles2D = $"%effect"

func spawn():
	modulate = Color(colors[index % colors.size()])
	effect.emitting = true
func ai():
	rotation_degrees = 360.0 / colors.size() * index + timeLived() / generationDuration * 360 - index / 6.0 * 360.0
	heart.global_rotation_degrees = 0
	PresetBulletAI.lockLauncher(self, launcher, true)
func succeedToHit(_dmg: float, _entity: EntityBase):
	launcher.storeEnergy(getDamage() * energyCollect)
	launcher.tryHeal(healAmount)
