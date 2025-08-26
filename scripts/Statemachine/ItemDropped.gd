extends RigidBody2D
class_name ItemDropped

var item: ItemStore.ItemType = ItemStore.ItemType.BASEBALL
var stackCount: int = 1
var targetPlayer: EntityBase = null

@onready var texture: Sprite2D = $"%texture"

func _process(_delta):
	texture.texture = ItemStore.getTexture(item)
func _physics_process(_delta):
	if !is_instance_valid(targetPlayer):
		targetPlayer = findPlayer()
	if is_instance_valid(targetPlayer):
		apply_central_force((targetPlayer.position - position).normalized() * 1000)
func findPlayer() -> EntityBase:
	var result = null
	var lastDistance = INF
	for player in get_tree().get_nodes_in_group("players"):
		if player is EntityBase:
			if position.distance_to(player.position) < lastDistance:
				lastDistance = position.distance_to(player.position)
				result = player
	return result

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
