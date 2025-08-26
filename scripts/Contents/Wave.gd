class_name Wave

var entity: PackedScene
var minCount: int = 1
var maxCount: int = 1
var isBoss: bool = false
var from: float = 0
var to: float = 0
var per: int = 0

static var current: int = 0
static var countBoost: float = 0.1 # 每波增加的敌人数量百分比，指数级
static var data: Array[Wave] = [
	# entity, minCount, maxCount, isBoss, from, to, per
	create(preload("res://components/Characters/Hen.tscn"), 1, 5, false, 0, INF, 1),
	create(preload("res://components/Characters/Chick.tscn"), 0, 0, true, 1, INF, 2)
]

static func create(
		entity_: PackedScene,
		minCount_: int = 1,
		maxCount_: int = 1,
		isBoss_: bool = false,
		from_: float = 0,
		to_: float = 0,
		per_: int = 0
	) -> Wave:
	var wave = Wave.new()
	wave.entity = entity_
	wave.minCount = minCount_
	wave.maxCount = maxCount_
	wave.isBoss = isBoss_
	wave.from = from_
	wave.to = to_
	wave.per = per_
	return wave
static func entityCountOf(wave: Wave) -> int:
	if wave.from <= current and wave.to >= current and int(current - wave.from) % wave.per == 0:
		if wave.isBoss:
			return 1
		else:
			return randi_range(int(wave.minCount), int(wave.maxCount * ((1 + countBoost) ** current)))
	return 0
static func spawn():
	for i in range(len(data)):
		var wave = data[i]
		for j in range(entityCountOf(wave)):
			EntityBase.generate(wave.entity, MathTool.randv2_range(500), true, wave.isBoss)
static func next():
	spawn()
	current += 1
