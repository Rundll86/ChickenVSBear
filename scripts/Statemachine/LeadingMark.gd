@tool
extends Node2D

@export var width: float = 75
@export var height: float = 100
@export var collapse: float = 0.25
@export var color: Color = Color(1, 1, 1)

func getPolygon() -> Array[Vector2]:
	return [
		Vector2(0, -height / 2),
		Vector2(width / 2, height / 2),
		Vector2(0, height * (1 - collapse) - height / 2),
		Vector2(-width / 2, height / 2),
	]
func _draw():
	draw_polygon(getPolygon(), [color])
func _process(_delta):
	queue_redraw()
