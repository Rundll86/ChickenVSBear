class_name PresetBulletAI

static func lockLauncher(bullet: BulletBase, launcher: EntityBase, onTexture: bool = false, useSummoned: bool = false):
	if useSummoned:
		if is_instance_valid(bullet.launcherSummoned):
			launcher = bullet.launcherSummoned
	bullet.position = launcher.texture.global_position if onTexture else launcher.position
static func forward(bullet: BulletBase, rotation: float):
	bullet.forward(Vector2.from_angle(rotation))
static func trace(bullet: BulletBase, target: Vector2, speed: float):
	bullet.rotation = lerp_angle(
		bullet.rotation,
		bullet.position.angle_to_point(target),
		speed
	)
static func faceToMouse(bullet: BulletBase):
	bullet.rotation = bullet.position.angle_to_point(bullet.get_global_mouse_position())
