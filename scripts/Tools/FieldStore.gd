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
	OFFSET_SHOOT,
	HEAL_ABILITY,
	EXTRA_APPLE_MAX,
	ENERGY_MULTIPILER,
	PENARATION_RESISTANCE,
	PRICE_REDUCTION,
	EXTRA_BULLET_COUNT,
	DROP_APPLE_RATE,
	FEED_COUNT_SHOW,
	FEED_COUNT_CAN_MADE,
	MAX_ENERGY,
	LUCK_VALUE,
}
static var entityMap = {
	Entity.MAX_HEALTH: "生命上限",
	Entity.DAMAGE_MULTIPILER: "伤害倍率",
	Entity.MOVEMENT_SPEED: "移动速度",
	Entity.ATTACK_SPEED: "攻击速度",
	Entity.CRIT_RATE: "暴击率",
	Entity.CRIT_DAMAGE: "暴击伤害",
	Entity.PENERATE: "穿透",
	Entity.OFFSET_SHOOT: "散射角",
	Entity.HEAL_ABILITY: "治疗量",
	Entity.EXTRA_APPLE_MAX: "苹果上限",
	Entity.ENERGY_MULTIPILER: "能量倍率",
	Entity.PENARATION_RESISTANCE: "穿透抗性",
	Entity.PRICE_REDUCTION: "饲料降价",
	Entity.EXTRA_BULLET_COUNT: "额外子弹",
	Entity.DROP_APPLE_RATE: "苹果掉落率",
	Entity.FEED_COUNT_SHOW: "饲料列表",
	Entity.FEED_COUNT_CAN_MADE: "可制作饲料",
	Entity.MAX_ENERGY: "能量上限",
	Entity.LUCK_VALUE: "幸运值",
}
static var entityMapType = {
	Entity.MAX_HEALTH: DataType.VALUE,
	Entity.DAMAGE_MULTIPILER: DataType.PERCENT,
	Entity.MOVEMENT_SPEED: DataType.PERCENT,
	Entity.ATTACK_SPEED: DataType.PERCENT,
	Entity.CRIT_RATE: DataType.PERCENT,
	Entity.CRIT_DAMAGE: DataType.PERCENT,
	Entity.PENERATE: DataType.PERCENT,
	Entity.OFFSET_SHOOT: DataType.ANGLE,
	Entity.HEAL_ABILITY: DataType.PERCENT,
	Entity.EXTRA_APPLE_MAX: DataType.VALUE,
	Entity.ENERGY_MULTIPILER: DataType.PERCENT,
	Entity.PENARATION_RESISTANCE: DataType.PERCENT,
	Entity.PRICE_REDUCTION: DataType.PERCENT,
	Entity.EXTRA_BULLET_COUNT: DataType.VALUE,
	Entity.DROP_APPLE_RATE: DataType.PERCENT,
	Entity.FEED_COUNT_SHOW: DataType.VALUE,
	Entity.FEED_COUNT_CAN_MADE: DataType.VALUE,
	Entity.MAX_ENERGY: DataType.VALUE,
	Entity.LUCK_VALUE: DataType.VALUE,
}
static var entityMaxValueMap = {
	Entity.CRIT_RATE: 1,
	Entity.PENERATE: 1,
	Entity.PENARATION_RESISTANCE: 1,
	Entity.PRICE_REDUCTION: 0.8,
	Entity.DROP_APPLE_RATE: 0.5,
	Entity.FEED_COUNT_SHOW: 6
}
static var entityApplier = {
	Entity.MAX_HEALTH: func(entity, value):
		entity.health += value
		return true
		,
	Entity.EXTRA_APPLE_MAX: func(entity, value):
		entity.inventoryMax[ItemStore.ItemType.APPLE] += value
		return true
		,
	Entity.EXTRA_BULLET_COUNT: func(entity, value):
		entity.fields[Entity.OFFSET_SHOOT] += value * 5
		return true
		,
}
static var entityViewCastMap = {
	Entity.EXTRA_APPLE_MAX: func(entity, _value):
		return entity.inventoryMax[ItemStore.ItemType.APPLE]
		,
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