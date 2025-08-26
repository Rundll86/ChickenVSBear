@tool
class_name FieldStore

enum DataType {
	VALUE,
	PERCENT,
	ANGLE
}
enum Entity {
	MAX_HEALTH,
	DAMAGE_MULTIPILER,
	MOVEMENT_SPEED,
	ATTACK_SPEED,
	CRIT_RATE,
	CRIT_DAMAGE,
	PENERATE,
	OFFSET_SHOOT
}
static var entityMap = {
	Entity.MAX_HEALTH: "最大生命值",
	Entity.DAMAGE_MULTIPILER: "伤害倍率",
	Entity.MOVEMENT_SPEED: "移动速度",
	Entity.ATTACK_SPEED: "攻击速度",
	Entity.CRIT_RATE: "暴击率",
	Entity.CRIT_DAMAGE: "暴击伤害",
	Entity.PENERATE: "穿透",
	Entity.OFFSET_SHOOT: "散射角"
}
static var entityMapType = {
	Entity.MAX_HEALTH: DataType.VALUE,
	Entity.DAMAGE_MULTIPILER: DataType.PERCENT,
	Entity.MOVEMENT_SPEED: DataType.PERCENT,
	Entity.ATTACK_SPEED: DataType.PERCENT,
	Entity.CRIT_RATE: DataType.PERCENT,
	Entity.CRIT_DAMAGE: DataType.PERCENT,
	Entity.PENERATE: DataType.PERCENT,
	Entity.OFFSET_SHOOT: DataType.ANGLE
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
static var bulletMapType = {
	Bullet.SPEED: DataType.VALUE,
	Bullet.DAMAGE: DataType.VALUE,
	Bullet.PENERATE: DataType.PERCENT
}