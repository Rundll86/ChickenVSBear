class_name Wave

# 元数据
var entity: String
var minCount: int = 1
var maxCount: int = 1
var isBoss: bool = false
var from: float = 0
var to: float = 0
var per: int = 0
# 实例数据
var entityPosition: Vector2

func duplicate() -> Wave:
	var wave = Wave.new()
	wave.entity = entity
	wave.minCount = minCount
	wave.maxCount = maxCount
	wave.isBoss = isBoss
	wave.from = from
	wave.to = to
	wave.per = per
	return wave

static var current: int = startWith(1)
static var WAVE_NORMAL = [
	# Wave.create("Hen", 1, 5, false, 0, INF, 1),
	# Wave.create("Cat", 1, 5, false, 0, INF, 1),
	Wave.create("Dog", 1, 5, false, 0, INF, 1),
	Wave.create("Chick", 0, 0, true, 9, INF, 15),
	Wave.create("Bear", 0, 0, true, 19, INF, 10),
	Wave.create("KukeMC", 0, 0, true, 14, INF, 20),
]
static var WAVE_TESTBOSS_ALL = [
	Wave.create("Chick", 0, 0, true, 0, INF, 3),
	Wave.create("KukeMC", 0, 0, true, 1, INF, 3),
	Wave.create("Bear", 0, 0, true, 2, INF, 3),
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
static func spawn() -> Array:
	var result: Array = []
	for i in range(len(data)):
		var wave: Wave = data[i]
		for j in range(entityCountOf(wave)):
			var currentWave = wave.duplicate()
			currentWave.entityPosition = MathTool.randv2_range(500)
			result.append(currentWave)
	return result
static func next(waves: Array):
	for wave in waves:
		if wave is EncodedObjectAsID:
			wave = instance_from_id(wave.get_instance_id())
		EntityBase.generate(ComponentManager.getCharacter(wave.entity), wave.entityPosition, true, wave.isBoss)
	current += 1
static func startWith(wave: int):
	return wave - 1
