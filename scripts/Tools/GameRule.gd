class_name GameRule

enum Difficulty {
	EASY,
	NORMAL,
	HARD,
	INSANE,
	EXPERT,
	MASTER,
}
static var difficulty: Difficulty = Difficulty.NORMAL # 难度倍数，可以写小数
static var allowFriendlyFire: bool = false # 是否允许友军伤害
static var bulletSpeedMultiplier: float = 1 # 子弹速度倍率
static var damageOffset: float = MathTool.percent(20) # 伤害随机浮动比例
static var beachballOffset: float = MathTool.percent(30) # 棒球掉落数随机浮动比例
static var damageLabelSpawnOffset: float = 10 # 伤害标签生成位置的随机偏移
static var itemDroppedSpawnOffset: float = 30 # 掉落物生成位置的随机偏移
static var appleDropRate: float = MathTool.percent(10) # 苹果掉落概率
static var refreshCountIncreasePercent: Vector2 = Vector2(MathTool.percent(10), MathTool.percent(50)) # 刷新所需的棒球数量的增加的百分比
static var entityCountBoostPerWave: float = MathTool.percent(10) # 每波敌人数量增加的百分比，倍数级
static var itemShowLifetime: int = 1500 # 物品展示组件如果设置了自动隐藏，那么隐藏前可以存活的时间
static var tipSpawnRateWhenGetDroppedItem: float = MathTool.percent(25) # 当玩家获取到掉落物时，提示的概率
static var entityHealthIncreasePerWave: float = MathTool.percent(5) # 每波敌人生命值增加的百分比，指数级
static var entityDamageIncreasePerWave: float = MathTool.percent(2.5) # 每波敌人伤害增加的百分比，指数级
static var entityLevelOffsetByWave: float = MathTool.percent(30) # 每波敌人等级根据当前波数随机浮动的比例
static var appleDropRateInfluenceByLuckValue: float = MathTool.percent(2) # 幸运值对苹果掉率的影响
static var critRateInfluenceByLuckValue: float = MathTool.percent(2.5) # 幸运值对暴击率的影响
static var penerateRateInfluenceByLuckValue: float = MathTool.percent(3) # 幸运值对穿透率的影响
