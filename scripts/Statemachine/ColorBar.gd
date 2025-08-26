@tool
extends Control
class_name ColorBar

@export var minValue: float = 0
@export var maxValue: float = 100
@export var currentValue: float = 50
@export var backColor: Color
@export var middleColor: Color
@export var frontColor: Color
@export var speed1: float = 0.9
@export var speed2: float = 0.01

var middleValue = 0
var frontValue = 0
var forwardDirection = -1

func getPercent(value: float):
	return (value - minValue) / (maxValue - minValue)
func setCurrent(value: float):
	forwardDirection = sign(value - currentValue)
	currentValue = value

func _ready():
	middleValue = currentValue
	frontValue = currentValue
func _draw():
	draw_rect(Rect2(0, 0, size.x, size.y), backColor)
	draw_rect(Rect2(0, 0, size.x * getPercent(middleValue), size.y), middleColor)
	draw_rect(Rect2(0, 0, size.x * getPercent(frontValue), size.y), frontColor)
func _process(_delta: float) -> void:
	middleValue = lerpf(middleValue, currentValue, speed1 if forwardDirection > 0 else speed2)
	frontValue = lerpf(frontValue, currentValue, speed1 if forwardDirection < 0 else speed2)
	queue_redraw()
