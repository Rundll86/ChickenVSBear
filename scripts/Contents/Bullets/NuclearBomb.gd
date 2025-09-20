extends BulletBase
class_name NuclearBomb

@onready var label: Label = $"%label"
@onready var anchor: Node2D = $"%anchor"

var countdown = 10000
var radius = 500

func spawn():
	hitbox.disabled = true
	hitbox.shape.radius = radius
	anchor.global_rotation = 0
func ai():
	speed *= 0.99
	PresetBulletAI.forward(self, rotation)
	label.text = "NUCLEAR WARNING %.1f" % ((countdown - timeLived()) / 1000)
	if timeLived() > countdown:
		tryDestroy()
func destroy(_b):
	EffectController.create(preload("res://components/Effects/NuclearExplosion.tscn"), global_position).shot()
	hitbox.disabled = false
	CameraManager.shake(5000, 250, func(_c, t, r): return t * r) # 震屏强度随进度递减
	await TickTool.frame(5)
