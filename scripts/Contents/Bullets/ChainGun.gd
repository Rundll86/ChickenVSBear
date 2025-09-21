extends BulletBase

@onready var anchor: Node2D = $"%anchor"

func spawn():
	for i in BulletBase.generate(ComponentManager.getBullet("PurpleCrystalSmall"), launcher, anchor.global_position, rotation):
		i.damage = damage
func ai():
	PresetBulletAI.lockLauncher(self, launcher, true)