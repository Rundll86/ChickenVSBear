class_name MathTool

static func rate(value: float):
	return randf() < value
static func randv2_range(offset: float):
	return Vector2(
		randf_range(-offset, offset),
		randf_range(-offset, offset)
	)
static func randc_from(array: Array):
	return array[randi() % array.size()]
static func signBeforeStr(value: float):
	return ("+" if value > 0 else "-" if value < 0 else "") + str(abs(value))