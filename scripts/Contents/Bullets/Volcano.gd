extends BulletBase
class_name Volcano

@onready var textureSword: Sprite2D = $%textureSword
@onready var anchor: Node2D = $%anchor

var rotates: float = 0

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
	for i in BulletBase.generate(
		ComponentManager.getBullet("VolcanoShadow"),
		launcher,
		textureSword.global_position,
		anchor.global_rotation,
		false, false, true, true
	):
		if i is VolcanoShadow:
			i.damage = damage
