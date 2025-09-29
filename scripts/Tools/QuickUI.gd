class_name QuickUI

static func smallText(text: String, center: bool = true):
	var label = Label.new()
	label.text = text
	label.theme = ComponentManager.getTheme("smallText")
	if center:
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	return label
static func graySmallText(text: String, center: bool = true):
	var label = Label.new()
	label.text = text
	label.label_settings = LabelSettings.new()
	label.label_settings.font_size = 12
	label.label_settings.font_color = Color(0.6, 0.6, 0.6, 1)
	if center:
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	return label
static func getWindowSize() -> Vector2:
	var result = DisplayServer.window_get_size()
	return result
