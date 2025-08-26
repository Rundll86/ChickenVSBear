class_name MathTool

static func rate(value: float):
	return randf() < value
static func randv2_range(offset: float):
	return Vector2(
		randf_range(-offset, offset),
		randf_range(-offset, offset)
	)