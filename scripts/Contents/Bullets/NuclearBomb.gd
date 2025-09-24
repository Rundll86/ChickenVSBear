extends BulletBase
class_name NuclearBomb

@onready var label: Label = $"%label"
@onready var anchor: Node2D = $"%anchor"
@onready var warn: ShaderStage = $"%warn"
@onready var warnbg: ShaderStage = $"%warnbg"

var countdown = 10000
var radius = 500

func spawn():
	hitbox.disabled = true
	hitbox.shape.radius = radius
	warnbg.size = Vector2.ONE * 2 * radius
	anchor.global_rotation = 0
func ai():
	speed *= 0.99
	PresetBulletAI.forward(self, rotation)
	if timeLived() > countdown:
		tryDestroy()
	else:
		warn.size = Vector2.ONE * 2 * radius * (timeLived() / countdown)
		label.text = "NUCLEAR WARNING %.1f" % ((countdown - timeLived()) / 1000)
func destroy(_b):
	EffectController.create(ComponentManager.getEffect("NuclearExplosion"), global_position).shot()
	hitbox.disabled = false
	CameraManager.shake(5000, 300, func(_c, t, r): return t * r) # 震屏强度随进度递减
	await TickTool.frame(5)
