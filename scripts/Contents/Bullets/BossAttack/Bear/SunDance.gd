extends BulletBase

@export var allColor: GradientTexture1D = null

@onready var leave1: Sprite2D = $"%leave1"
@onready var leave2: Sprite2D = $"%leave2"
@onready var leave3: Sprite2D = $"%leave3"
@onready var leave4: Sprite2D = $"%leave4"

var myColor: Color

func register():
	speed = 0
	damage = 10
	penerate = 1
func spawn():
	myColor = allColor.gradient.sample(randf())
	setColor(myColor)

func ai():
	rotation_degrees += 1
	PresetBulletAI.lockLauncher(self, launcher, true)

func setColor(color: Color):
	leave1.modulate = Color(color) * 2
	leave2.modulate = Color(color) * 4
	leave3.modulate = Color(color) * 8
	leave4.modulate = Color.WHITE * 16
