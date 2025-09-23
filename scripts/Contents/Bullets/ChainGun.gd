extends BulletBase

var count: int = 1
var splits: float = 10.0

@onready var anchor: Node2D = $"%anchor"

func spawn():
	for j in count:
		for i in BulletBase.generate(ComponentManager.getBullet("PurpleCrystalSmall"), launcher, anchor.global_position, rotation):
			i.damage = damage
			var dir = Vector2.from_angle(i.rotation).rotated(deg_to_rad(-90))
			i.global_position += dir * (count - j * 2) * splits / 2
func ai():
	PresetBulletAI.lockLauncher(self, launcher, true)
