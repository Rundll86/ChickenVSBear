@tool
extends Node2D
class_name ShaderStage

@export var size: Vector2 = Vector2.ONE * 100
@export var color: Color = Color.WHITE

func _draw():
	draw_rect(Rect2(size / -2, size), color)
func _process(_delta):
	queue_redraw()
