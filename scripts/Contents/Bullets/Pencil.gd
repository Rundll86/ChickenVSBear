extends BulletBase

func spawn():
	await TickTool.millseconds(1000)
	hitbox.disabled = false
func ai():
	texture.global_rotation = 0
