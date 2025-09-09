@tool
extends ColorBar
class_name VerticalColorBar

func _draw():
	draw_style_box(backBox, Rect2(0, 0, size.x, size.y))
	draw_style_box(middleBox2 if forwardDirection > 0 else middleBox1, Rect2(0, size.y * (1 - getPercent(middleValue)), size.x, size.y * getPercent(middleValue)))
	draw_style_box(frontBox, Rect2(0, size.y * (1 - getPercent(frontValue)), size.x, size.y * getPercent(frontValue)))
