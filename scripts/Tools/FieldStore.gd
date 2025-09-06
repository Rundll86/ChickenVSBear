@tool
class_name FieldStore

enum DataType {
	VALUE,
	INTEGER,
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
	SAVE_ENERGY,
	ENERGY_REGENERATION,
	DROPPED_ITEM_COLLECT_RADIUS,
	BULLET_SPLIT,
	BULLET_REFRACTION,
	BULLET_TRACE,
	GRAVITY
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
	Entity.ENERGY_MULTIPILER: "储能倍率",
	Entity.PENARATION_RESISTANCE: "穿透抗性",
	Entity.PRICE_REDUCTION: "饲料降价",
	Entity.EXTRA_BULLET_COUNT: "多重射击",
	Entity.DROP_APPLE_RATE: "苹果掉落率",
	Entity.FEED_COUNT_SHOW: "饲料列表",
	Entity.FEED_COUNT_CAN_MADE: "可制作饲料",
	Entity.MAX_ENERGY: "能量上限",
	Entity.LUCK_VALUE: "幸运值",
	Entity.SAVE_ENERGY: "节能",
	Entity.ENERGY_REGENERATION: "能量再生效率",
	Entity.DROPPED_ITEM_COLLECT_RADIUS: "拾取距离",
	Entity.BULLET_SPLIT: "分裂",
	Entity.BULLET_REFRACTION: "折射",
	Entity.BULLET_TRACE: "追踪",
	Entity.GRAVITY: "引力",
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
	Entity.EXTRA_APPLE_MAX: DataType.INTEGER,
	Entity.ENERGY_MULTIPILER: DataType.PERCENT,
	Entity.PENARATION_RESISTANCE: DataType.PERCENT,
	Entity.PRICE_REDUCTION: DataType.PERCENT,
	Entity.EXTRA_BULLET_COUNT: DataType.VALUE,
	Entity.DROP_APPLE_RATE: DataType.PERCENT,
	Entity.FEED_COUNT_SHOW: DataType.INTEGER,
	Entity.FEED_COUNT_CAN_MADE: DataType.INTEGER,
	Entity.MAX_ENERGY: DataType.VALUE,
	Entity.LUCK_VALUE: DataType.VALUE,
	Entity.SAVE_ENERGY: DataType.PERCENT,
	Entity.ENERGY_REGENERATION: DataType.PERCENT,
	Entity.DROPPED_ITEM_COLLECT_RADIUS: DataType.VALUE,
	Entity.BULLET_SPLIT: DataType.VALUE,
	Entity.BULLET_REFRACTION: DataType.VALUE,
	Entity.BULLET_TRACE: DataType.PERCENT,
	Entity.GRAVITY: DataType.VALUE,
}
static var entityMaxValueMap = {
	Entity.CRIT_RATE: 0.8,
	Entity.PENERATE: 0.8,
	Entity.PENARATION_RESISTANCE: 0.5,
	Entity.PRICE_REDUCTION: 0.4,
	Entity.DROP_APPLE_RATE: 0.4,
	Entity.FEED_COUNT_SHOW: 6,
	Entity.BULLET_TRACE: 1,
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
}
static var entityViewCastMap = {
	Entity.EXTRA_APPLE_MAX: func(entity, _value):
		return entity.inventoryMax[ItemStore.ItemType.APPLE]
		,
}