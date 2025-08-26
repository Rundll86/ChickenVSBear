extends EntityBase
class_name Rooster

func ai():
	var vector = Vector2(
		Input.get_axis("m_left", "m_right"),
		Input.get_axis("m_up", "m_down")
	)
	move(vector)
