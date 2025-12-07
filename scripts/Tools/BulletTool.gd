class_name BulletTool

static func fromArea(area: Area2D) -> BulletBase:
	if area is BulletBase:
		return area as BulletBase
	else:
		return null
static func canDamage(bullet: BulletBase, target: EntityBase) -> bool:
	if !bullet or !target or !bullet.launcher: return false
	if target.currentInvinsible: return false
	if !bullet.canDamageSelf && target == bullet.launcher: return false
	if !GameRule.allowFriendlyFire:
		if target.isPlayer() == bullet.launcher.isPlayer() and bullet.launcher.currentFocusedBoss != target: return false
	return true
static func findClosetBullet(to: Vector2, fromTree: SceneTree) -> BulletBase:
	var result: BulletBase = null
	var lastDistance = INF
	for bullet in fromTree.get_nodes_in_group("bullets"):
		if to.distance_to(bullet.position) < lastDistance:
			lastDistance = to.distance_to(bullet.position)
			result = bullet
	return result
static func findClosetBulletCanDamage(to: Vector2, fromTree: SceneTree, target: EntityBase) -> BulletBase:
	var result: BulletBase = null
	var lastDistance = INF
	for bullet in fromTree.get_nodes_in_group("bullets"):
		if canDamage(bullet, target):
			if to.distance_to(bullet.position) < lastDistance:
				lastDistance = to.distance_to(bullet.position)
				result = bullet
	return result
