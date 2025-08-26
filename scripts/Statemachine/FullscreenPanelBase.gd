@tool
extends Control
class_name FullscreenPanelBase

@onready var animator = $"%animator"

func hidePanel():
	animator.play("hide")
	await animator.animation_finished
	visible = false
	afterClose()
func showPanel():
	beforeOpen()
	visible = true
	animator.play("show")
	await animator.animation_finished

func _ready():
	visible = false

# 钩子
func beforeOpen():
	pass
func afterClose():
	pass
