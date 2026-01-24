extends CanvasLayer
class_name UIState

static var items: PanelContainer
static var fields: VBoxContainer
static var fieldsAnimator: AnimationPlayer
static var player: EntityBase
static var bossbar: EntityStateBar
static var currentPanel: FullscreenPanelBase
static var panels: Control
static var energyPercent: ColorBar
static var itemCollect: VBoxContainer
static var skillIconContainer: VBoxContainer
static var tips: VBoxContainer

func _ready():
	bossbar = $%bossbar
	panels = $%panels
	energyPercent = $%percent
	itemCollect = $%itemCollect
	skillIconContainer = $%skillContainer
	tips = $%tips
	setPanel("Starter")
func _process(_delta):
	bossbar.visible = !!bossbar.entity
func _physics_process(_delta):
	if is_instance_valid(player):
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
			if player.fields[i] == EntityBase.TITLE_FLAG:
				fields.add_child(QuickUI.graySmallText(i))
			else:
				fields.add_child(FieldShow.create(i, player.fields[i], false, player, true))
		fieldsAnimator.play("show")
	if Input.is_action_just_released("showFields"):
		fieldsAnimator.play("hide")
	if Input.is_action_just_pressed("pause"):
		if currentPanel:
			if currentPanel.name != "MakeFeed":
				closeCurrentPanel()
		else:
			setPanel("Pause")
	if Input.is_action_just_pressed("openWeapon"):
		var canOpen = true
		if currentPanel:
			if currentPanel.name == "Weapon":
				closeCurrentPanel()
				canOpen = false
			elif ["MakeFeed", "GameOver"].has(currentPanel.name):
				canOpen = false
		if canOpen:
			setPanel("Weapon")

static func setPanel(targetName: String = "", args: Array = []):
	currentPanel = null
	for panel in panels.get_children():
		if panel is FullscreenPanelBase:
			if panel.name == targetName:
				currentPanel = panel
				panel.showPanel(args)
			else:
				panel.hidePanel()
static func closeCurrentPanel():
	setPanel()
static func showTip(text: String, destroyAfter: float = -1):
	var box = TipBox.create(text)
	tips.add_child(box)
	if destroyAfter > 0:
		await TickTool.millseconds(destroyAfter * 1000)
		box.destroy()
	else:
		return box
