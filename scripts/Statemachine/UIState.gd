extends CanvasLayer
class_name UIState

@onready var baseball = $"%baseball"
@onready var basketball = $"%basketball"

static var player: EntityBase = null
static var bossbar: EntityStateBar

func _ready():
	bossbar = $"%bossbar"
func _process(_delta):
	bossbar.visible = !!bossbar.entity
func _physics_process(_delta):
	if is_instance_valid(player):
		baseball.count = player.inventory[ItemStore.ItemType.BASEBALL]
		basketball.count = player.inventory[ItemStore.ItemType.BASKETBALL]
