extends BulletBase
class_name Volcano

@onready var textureSword: Sprite2D = $%textureSword
@onready var anchor: Node2D = $%anchor

var rotates: float = 0
var count: int = 0
var dmg5: float = 0
var splitAngle: float = 10

func register():
	animator.speed_scale = launcher.fields.get(FieldStore.Entity.ATTACK_SPEED)
func ai():
	PresetBulletAI.lockLauncher(self, launcher, true)
	rotation = lerp_angle(
		rotation,
		position.angle_to_point(get_global_mouse_position()),
		rotates
	)

func generateShadow():
	var startAngle = rotation - deg_to_rad(count * splitAngle / 2)
	for i in count:
		for bullet in BulletBase.generate(
			ComponentManager.getBullet("VolcanoShadow"),
			launcher,
			position,
			startAngle + i * deg_to_rad(splitAngle),
			false, false, true, true
		):
			if bullet is VolcanoShadow:
				bullet.baseDamage = baseDamage * dmg5
