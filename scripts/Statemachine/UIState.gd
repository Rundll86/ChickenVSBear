extends CanvasLayer
class_name UIState

@onready var baseball = $"%baseball"
@onready var basketball = $"%basketball"

static var player: EntityBase = null
static var bossbar: EntityStateBar
static var currentPanel: FullscreenPanelBase = null
static var panels: Control

func _ready():
	bossbar = $"%bossbar"
	panels = $"%panels"
func _process(_delta):
	bossbar.visible = !!bossbar.entity
func _physics_process(_delta):
	if is_instance_valid(player):
		baseball.count = player.inventory[ItemStore.ItemType.BASEBALL]
		basketball.count = player.inventory[ItemStore.ItemType.BASKETBALL]
	if currentPanel:
		WorldManager.rootNode.process_mode = Node.PROCESS_MODE_DISABLED
	else:
		WorldManager.rootNode.process_mode = Node.PROCESS_MODE_INHERIT

static func setPanel(targetName: String = ""):
	currentPanel = null
	for panel in panels.get_children():
		if panel is FullscreenPanelBase:
			if panel.name == targetName:
				currentPanel = panel
				panel.showPanel()
			else:
				panel.hidePanel()
