@tool
class_name FieldStore

enum Entity {
	MAX_HEALTH,
	DAMAGE_MULTIPILER,
	MOVEMENT_SPEED,
	ATTACK_SPEED,
	CRIT_RATE,
	CRIT_DAMAGE,
	PENERATE
}
static var entityMap = {
	Entity.MAX_HEALTH: "最大生命值",
	Entity.DAMAGE_MULTIPILER: "伤害倍率",
	Entity.MOVEMENT_SPEED: "移动速度",
	Entity.ATTACK_SPEED: "攻击速度",
	Entity.CRIT_RATE: "暴击率",
	Entity.CRIT_DAMAGE: "暴击伤害",
	Entity.PENERATE: "穿透"
}

enum Bullet {
	SPEED,
	DAMAGE,
	PENERATE
}
static var bulletMap = {
	Bullet.SPEED: "速度",
	Bullet.DAMAGE: "伤害",
	Bullet.PENERATE: "穿透"
}