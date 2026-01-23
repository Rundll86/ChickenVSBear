extends BulletBase
class_name AcidBulletBase

enum AcidType {
    STRONG,
    WEAK,
}
@export var acidType: AcidType = AcidType.STRONG

var arg1: float = 0
var arg2: float = 0
var arg3: float = 0

func register():
    scale.y *= MathTool.randomChoiceFrom([-1, 1])
func ai():
    PresetBulletAI.forward(self, rotation)
