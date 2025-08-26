extends CharacterBody2D
class_name EntityBase # 这是个抽象类

@export var maxHealth: float = 100
@export var movementSpeed: float = 1

@onready var animatree: AnimationTree = $"%animatree"
@onready var texture: AnimatedSprite2D = $"%texture"
@onready var hurtbox: Area2D = $"%hurtbox"

var health: float = 0

var lastDirection: int = 1

func _ready():
	health = maxHealth
func _process(_delta):
	health = clamp(health, 0, maxHealth)
	animatree.set("parameters/blend_position", lerpf(animatree.get("parameters/blend_position"), lastDirection, 0.1))
func _physics_process(_delta: float) -> void:
	velocity = Vector2.ZERO
	ai()
	move_and_slide()

# 通用方法
func move(direction: Vector2):
	velocity = direction.normalized() * movementSpeed * 150 * abs(animatree.get("parameters/blend_position"))
	var currentDirection = sign(direction.x)
	if currentDirection != 0:
		lastDirection = currentDirection

# 抽象方法
func ai():
	pass
func attack(_type: int):
	pass
