extends Node2D
class_name ObstacleStateBar

@export var obstacle: ObstacleBase

@onready var healthBar: ColorBar = $%health
@onready var currentLabel: Label = $%current
@onready var maxLabel: Label = $%max
@onready var levelLabelContainer: HBoxContainer = $%levelLabel

func forceSync():
	healthBar.maxValue = obstacle.healthMax
	healthBar.currentValue = obstacle.health
	healthBar.forceSync()
func applyText():
	currentLabel.text = "%d" % obstacle.health
	maxLabel.text = "%d" % obstacle.healthMax
