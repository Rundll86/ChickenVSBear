class_name QuickUI

static func smallText(text: String, center: bool = true):
	var label = Label.new()
	label.text = text
	label.theme = preload("res://themes/smallText.tres")
	if center:
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	return label
