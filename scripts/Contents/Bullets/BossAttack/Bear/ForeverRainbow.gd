extends BulletBase

@export var allColor: GradientTexture1D = null

var myColor: Color

func register():
	baseDamage = 1
	penerate = 1
func spawn():
	myColor = allColor.gradient.sample(randf())
	setColor(myColor)

func ai():
	speed = (11000 - timeLived()) / 11000 * initialSpeed
	rotation_degrees += speed / 10
	PresetBulletAI.forward(self, rotation)

func setColor(color: Color):
	texture.self_modulate = color
	texture.modulate.v *= 10
