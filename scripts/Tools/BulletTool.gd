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
