extends RigidBody2D
class_name ItemDropped

var item: ItemStore.ItemType = ItemStore.ItemType.BASEBALL
var stackCount: int = 1
var targetPlayer: EntityBase = null
var collecting: bool = false

@onready var texture: Sprite2D = $"%texture"
@onready var animator: AnimationPlayer = $"%animator"

func _ready():
	apply_force(MathTool.randv2_range(30000), MathTool.randv2_range(10))
func _process(_delta):
	texture.texture = ItemStore.getTexture(item)
func _physics_process(_delta):
	if !is_instance_valid(targetPlayer):
		targetPlayer = findPlayer()
	if is_instance_valid(targetPlayer):
		if collecting:
			linear_velocity = Vector2.ZERO
		else:
			var direction = (targetPlayer.position - position).normalized()
			var speed = 5000.0 / ((targetPlayer.position - position).length() ** (1 / 3.0))
			apply_central_force(direction * speed)
			if position.distance_to(targetPlayer.position) < targetPlayer.fields.get(FieldStore.Entity.DROPPED_ITEM_COLLECT_RADIUS):
				targetPlayer.collectItem(item, stackCount)
				collect()

func findPlayer() -> EntityBase:
	var result = null
	var lastDistance = INF
	for player in get_tree().get_nodes_in_group("players"):
		if player is EntityBase:
			if position.distance_to(player.position) < lastDistance:
				lastDistance = position.distance_to(player.position)
				result = player
	return result
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
