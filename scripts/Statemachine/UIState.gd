extends CanvasLayer
class_name UIState

@onready var baseball = $"%baseball"
@onready var basketball = $"%basketball"
@onready var apple = $"%apple"
@onready var items = $"%items"
@onready var energyLabel: Label = $"%energy"
@onready var energyMaxLabel: Label = $"%energyMax"

static var player: EntityBase = null
static var bossbar: EntityStateBar
static var currentPanel: FullscreenPanelBase = null
static var panels: Control
static var energyPercent: ColorBar
static var itemCollect: VBoxContainer

func _ready():
	bossbar = $"%bossbar"
	panels = $"%panels"
	energyPercent = $"%percent"
	itemCollect = $"%itemCollect"
func _process(_delta):
	bossbar.visible = !!bossbar.entity
func _physics_process(_delta):
	if is_instance_valid(player):
		energyLabel.text = "%.2f" % player.energy
		energyMaxLabel.text = "%.1f" % player.fields.get(FieldStore.Entity.MAX_ENERGY)
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
static func closeCurrentPanel():
	setPanel()
