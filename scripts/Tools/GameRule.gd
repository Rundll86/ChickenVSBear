class_name GameRule

enum Difficulty {
	EASY,
	NORMAL,
	HARD,
	INSANE,
	EXPERT,
	MASTER,
}
static var difficulty: Difficulty = Difficulty.NORMAL
static var allowFriendlyFire: bool = false # 是否允许友军伤害
static var bulletSpeedMultiplier: float = 1 # 子弹速度倍率
static var damageOffset: float = 0.2 # 伤害随机浮动比例，默认20%，即10的基础伤害会应用为8~12
static var damageLabelSpawnOffset: float = 10 # 伤害标签生成位置的随机偏移
static var itemDroppedSpawnOffset: float = 30 # 掉落物生成位置的随机偏移
static var appleDropRate: float = 0.1 # 苹果掉落概率
static var refreshCountIncreasePercent: Vector2 = Vector2(0.4, 1.1) # 刷新所需的棒球数量的增加的百分比，随机，默认为40%~110%
static var entityCountBoostPerWave: float = 0.1 # 每波敌人数量增加的百分比，倍数级
static var itemShowStayTime: int = 1500 # 物品展示组件如果设置了自动隐藏，那么隐藏前可以存活的时间
static var tipSpawnRateWhenGetDroppedItem: float = 0.25 # 当玩家获取到掉落物时，提示的概率
static var entityHealthIncreasePerWave: float = 0.1 # 每波敌人生命值增加的百分比，指数级
static var entityDamageIncreasePerWave: float = 0.05 # 每波敌人伤害增加的百分比，指数级
static var entityLevelOffsetByWave: float = 0.3 # 每波敌人等级根据当前波数随机浮动的比例