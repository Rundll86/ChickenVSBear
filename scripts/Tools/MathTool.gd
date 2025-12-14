class_name MathTool

static func rate(value: float) -> bool:
	return randf() < value
static func randv2_range(offset: float):
	return Vector2(
		randf_range(-offset, offset),
		randf_range(-offset, offset)
	)
static func randc_from(array: Array):
	return array[randi() % array.size()]
static func randc_from_weights(indexes: Array, weights: Array[int]):
	var totals: Array = []
	var index = 0
	for i in indexes:
		for j in range(weights[index]):
			totals.append(i)
		index += 1
	return randc_from(totals)
static func signBeforeStr(value: float):
	return ("+" if value > 0 else "-" if value < 0 else "") + str(abs(value))
static func percent(value: float):
	return value / 100
static func shrimpRate(value: float):
	return floor(value) + int(rate(value - floor(value)))
static func getClosestIntersection(a: Vector2, b: Vector2, r: float) -> Vector2:
	var ab = b - a
	var distance = ab.length()
	if distance < 0.00001:
		return a + Vector2.RIGHT * r
	var abNormalized = ab / distance
	var distanceB = distance
	if distanceB <= r:
		return b
	var intersection = a + abNormalized * r
	return intersection
static func priority(a, b):
	return a if a else b
