extends BulletBase

var count: int = 0
var splits: float = 0

@onready var anchor: Node2D = $"%anchor"

func spawn():
	for j in count:
		for i in BulletBase.generate(
			ComponentManager.getBullet("PurpleCrystalSmall"),
			launcher,
			anchor.global_position,
			rotation + deg_to_rad(splits * randf_range(-1, 1))
		):
			if i is BulletBase:
				var dir = Vector2.from_angle(i.rotation).rotated(deg_to_rad(-90))
				i.baseDamage = baseDamage
				i.position += dir * (count - j * 2) * 10 / 2
func ai():
	PresetBulletAI.lockLauncher(self, launcher, true)
