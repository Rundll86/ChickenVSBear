extends CanvasLayer
class_name UIState

@onready var baseball = $"%baseball"
@onready var basketball = $"%basketball"
@onready var apple = $"%apple"
@onready var items = $"%items"
@onready var energyLabel: Label = $"%energy"
@onready var energyMaxLabel: Label = $"%energyMax"
@onready var fields: VBoxContainer = $"%fields"
@onready var fieldsAnimator: AnimationPlayer = $"%fieldsAnimator"

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
	if Input.is_action_just_pressed("showFields"):
		for i in fields.get_children():
			fields.remove_child(i)
		for i in player.fields:
			fields.add_child(FieldShow.create(i, player.fields[i], false))
		fieldsAnimator.play("show")
	if Input.is_action_just_released("showFields"):
		fieldsAnimator.play("hide")
	if Input.is_action_just_pressed("pause"):
		if currentPanel:
			if currentPanel.name == "Pause":
				closeCurrentPanel()
		else:
			setPanel("Pause")

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
