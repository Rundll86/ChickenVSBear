extends BulletBase
class_name AcidBulletBase

enum AcidType {
	STRONG,
	WEAK,
}
@export var acidType: AcidType = AcidType.STRONG

var arg1 = 0
var arg2 = 0
var arg3 = 0

var randomPercent: float = 0
var storm: AcidStormBullet = null

func register():
	scale.y *= MathTool.randomChoiceFrom([-1, 1])
	randomPercent = randf_range(0, 1)
func ai():
	if is_instance_valid(storm):
		position = storm.position + Vector2.from_angle(deg_to_rad((lifeTimePercent() + randomPercent) * 360)) * 150 * (1 - lifeTimePercent())
		rotation = storm.position.angle_to_point(position) + deg_to_rad(90)
	else:
		tryDestroy()
