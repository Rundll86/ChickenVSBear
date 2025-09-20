extends RigidBody2D
class_name ItemDropped

var item: ItemStore.ItemType = ItemStore.ItemType.BASEBALL
var stackCount: int = 1
var targetPlayer: EntityBase = null
var collecting: bool = false

@onready var texture: Sprite2D = $"%texture"
@onready var animator: AnimationPlayer = $"%animator"

func _ready():
	await TickTool.millseconds(100)
	body_entered.connect(
		func(body):
			if body is ItemDropped and !body.collecting:
				if body.item == item:
					body.stackCount += stackCount
					collect()
	)
func _process(_delta):
	texture.texture = ItemStore.getTexture(item)
func _physics_process(_delta):
	if !is_instance_valid(targetPlayer):
		targetPlayer = EntityTool.findClosetPlayer(position, WorldManager.tree)
	if is_instance_valid(targetPlayer):
		if collecting:
			linear_velocity = Vector2.ZERO
		else:
			var direction = (targetPlayer.position - position).normalized()
			var speed = 1000.0 * targetPlayer.fields.get(FieldStore.Entity.GRAVITY) / ((targetPlayer.position - position).length() ** (1 / 3.0))
			apply_central_force(direction * speed)
			angular_velocity = linear_velocity.length() ** (1.0 / 2.25) # 角速度=线速度的2.25次根号
			if position.distance_to(targetPlayer.position) < targetPlayer.fields.get(FieldStore.Entity.DROPPED_ITEM_COLLECT_RADIUS):
				if targetPlayer.sprinting:
					apply_central_force((position - targetPlayer.texture.global_position).normalized() * targetPlayer.velocity.length() * 10)
				else:
					if targetPlayer.inventoryMax[item] > targetPlayer.inventory[item]:
						targetPlayer.collectItem(item, stackCount)
						collect()

func collect():
	collecting = true
	animator.play("collect")
	await animator.animation_finished
	queue_free()

static func generate(
		itemType: ItemStore.ItemType,
		count: int,
		spawnPosition: Vector2,
		addToWorld: bool = true
	):
	var instance: ItemDropped = preload("res://components/UI/ItemDropped.tscn").instantiate()
	instance.item = itemType
	instance.stackCount = count
	instance.position = spawnPosition
	if addToWorld:
		WorldManager.rootNode.call_deferred("add_child", instance)
	return instance
