class_name Composables

static func useHistoryStack(input: LineEdit):
	var stack = Reference.new([input.text])
	var lastText = Reference.new("")
	var getLast = func(index: int):
			return stack.getData()[stack.getData().size() - index - 1]
	input.text_changed.connect(func(text):
		lastText.setData(text)
		stack.getData().append(text)
	)
	return [
		stack,
		getLast,
		lastText
	]
