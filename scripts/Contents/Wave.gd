class_name Wave

var entity: String
var minCount: int = 1
var maxCount: int = 1
var isBoss: bool = false
var from: float = 0
var to: float = 0
var per: int = 0

static var current: int = 0
static var WAVE_NORMAL = [
	Wave.create("Hen", 1, 5, false, 0, INF, 1),
	Wave.create("Chick", 0, 0, true, 9, INF, 15),
	Wave.create("Bear", 0, 0, true, 19, INF, 10),
	Wave.create("KukeMC", 0, 0, true, 14, INF, 20),
]
static var WAVE_TESTBOSS_ALL = [
	Wave.create("Chick", 0, 0, true, 0, INF, 10),
	Wave.create("KukeMC", 0, 0, true, 0, INF, 10),
	Wave.create("Bear", 0, 0, true, 0, INF, 10),
]
static var WAVE_TESTBOSS_KUKE = [
	Wave.create("KukeMC", 0, 0, true, 0, INF, 10),
]
static var WAVE_TESTBOSS_BEAR = [
	Wave.create("Bear", 0, 0, true, 0, INF, 10),
]
static var WAVE_TESTBOSS_CHICK = [
	Wave.create("Chick", 0, 0, true, 0, INF, 10),
]
static var WAVE_EMPTY = []
static var data = WAVE_NORMAL

static func customStart():
	if false:
		var furryr = EntityBase.generate(ComponentManager.getCharacter("Bear"), MathTool.randv2_range(500), true, false)
		var kukemc = EntityBase.generate(ComponentManager.getCharacter("KukeMC"), MathTool.randv2_range(500), true, false)
		furryr.currentFocusedBoss = kukemc
		kukemc.currentFocusedBoss = furryr
static func create(
		entity_: String,
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
			return randi_range(ceil(wave.minCount), floor(wave.maxCount * (1 + GameRule.entityCountBoostPerWave * current)))
	return 0
static func spawn():
	for i in range(len(data)):
		var wave = data[i]
		for j in range(entityCountOf(wave)):
			EntityBase.generate(ComponentManager.getCharacter(wave.entity), MathTool.randv2_range(500), true, wave.isBoss)
static func next():
	if current == 0:
		customStart()
	spawn()
	current += 1
