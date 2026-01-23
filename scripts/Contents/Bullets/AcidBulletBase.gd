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

func register():
    scale.y *= MathTool.randomChoiceFrom([-1, 1])
func ai():
    PresetBulletAI.forward(self, rotation)
