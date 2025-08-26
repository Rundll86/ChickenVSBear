extends CharacterBody2D
class_name EntityBase # 这是个抽象类

@export var maxHealth: float = 100
@export var movementSpeed: float = 100

var health: float = 0

func _ready():
	health = maxHealth
func _process(_delta):
	health = clamp(health, 0, maxHealth)
func _physics_process(_delta: float) -> void:
	velocity = Vector2.ZERO
	ai()
	move_and_slide()

# 通用方法
func move(direction: Vector2):
	velocity = direction.normalized() * movementSpeed

# 抽象方法
func ai():
	pass
func attack(_type: int):
	pass
