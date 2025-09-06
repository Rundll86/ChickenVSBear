@tool
extends Control
class_name ColorBar

@export var minValue: float = 0
@export var maxValue: float = 100
@export var currentValue: float = 50
@export var backBox: StyleBox
@export var middleBox1: StyleBox
@export var middleBox2: StyleBox
@export var frontBox: StyleBox
@export var speed1: float = 0.8
@export var speed2: float = 0.01

var middleValue = 0
var frontValue = 0
var forwardDirection = -1
var lastChangeTime = 0

func getPercent(value: float):
	return (value - minValue) / (maxValue - minValue)
func setCurrent(value: float):
	if value == currentValue:
		return
	forwardDirection = sign(value - currentValue)
	currentValue = clamp(value, minValue, maxValue)
	lastChangeTime = WorldManager.getTime()
func forceSync():
	middleValue = currentValue
	frontValue = currentValue

func _ready():
	forceSync()
	lastChangeTime = WorldManager.getTime()
func _draw():
	draw_style_box(backBox, Rect2(0, 0, size.x, size.y))
	draw_style_box(middleBox2 if forwardDirection > 0 else middleBox1, Rect2(0, 0, size.x * getPercent(middleValue), size.y))
	draw_style_box(frontBox, Rect2(0, 0, size.x * getPercent(frontValue), size.y))
func _physics_process(_delta: float) -> void:
	if WorldManager.getTime() - lastChangeTime > GameRule.detainTime:
		middleValue = lerpf(middleValue, currentValue, speed1 if forwardDirection > 0 else speed2)
	frontValue = lerpf(frontValue, currentValue, speed1 if forwardDirection < 0 else speed2)
	queue_redraw()
