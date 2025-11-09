@tool
extends Control
class_name FullscreenPanelBase

@onready var animator = $"%animator"

func hidePanel():
	animator.play("hide")
	await animator.animation_finished
	visible = false
	afterClose()
func showPanel(args: Array = []):
	beforeOpen(args)
	visible = true
	animator.play("show")
	await animator.animation_finished

# 钩子
func beforeOpen(_args: Array = []):
	pass
func afterClose():
	pass
