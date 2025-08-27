extends CanvasLayer
class_name UIState

@onready var baseball = $"%baseball"
@onready var basketball = $"%basketball"
@onready var apple = $"%apple"
@onready var items = $"%items"
@onready var energy = $"%energy"

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
		energy.text = "%.1f"%player.energy
		for i in items.get_children():
			var item = i as ItemShow
			item.count = player.inventory.get(item.type)
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
