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

static var current: int = startWith(1) if WorldManager.isRelease() else startWith(1)
static var WAVE_NORMAL = [
	Wave.create("Hen", 1, 3, false, 0, INF, 1),
	Wave.create("Cat", 1, 5, false, 0, INF, 1),
	Wave.create("Dog", 1, 2, false, 0, INF, 1),
	Wave.create("MTY", 0, 1, false, 4, INF, 4),
	Wave.create("Chick", 0, 0, true, 9, INF, 20),
	Wave.create("KukeMC", 0, 0, true, 19, INF, 20),
	Wave.create("Bear", 0, 0, true, 29, INF, 20),
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
static var data = WAVE_NORMAL if WorldManager.isRelease() else WAVE_NORMAL

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
static func hasBoss() -> bool:
	for wave in data:
		if canSpawn(wave):
			if wave.isBoss:
				return true
	return false
static func canSpawn(wave: Wave) -> bool:
	return wave.from <= current and wave.to >= current and int(current - wave.from) % wave.per == 0
static func entityCountOf(wave: Wave) -> int:
	if canSpawn(wave):
		if wave.isBoss:
			return 1
		elif !hasBoss():
			return randi_range(ceil(wave.minCount), floor(wave.maxCount * (1 + GameRule.entityCountBoostPerWave * current)))
	return 0
static func spawn(center: Vector2) -> Array:
	var result: Array = []
	for i in range(len(data)):
		var wave: Wave = data[i]
		for j in range(entityCountOf(wave)):
			var currentWave = wave.duplicate()
			currentWave.entityPosition = MathTool.randomRingPoint(200, 1000) + center
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
