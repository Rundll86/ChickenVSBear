@tool
extends Node2D

@export var target: Node2D
@export var offsetPosition: Vector2 = Vector2.ZERO
@export var offsetRotation: float = 0.0
@export var enablePosition: bool = false
@export var enableRotation: bool = false

func _process(_delta):
	if is_instance_valid(target):
		if enablePosition:
			global_position = target.global_position + offsetPosition
		if enableRotation:
			global_rotation = target.global_rotation + deg_to_rad(offsetRotation)
