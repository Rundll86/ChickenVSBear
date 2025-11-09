@tool
extends FullscreenPanelBase

@onready var diffEdit: HSlider = $"%diffEdit"
@onready var startBtn: Button = $"%startBtn"
@onready var levelShow: Label = $"%levelShow"
@onready var hostInput: LineEdit = $"%hostInput"
@onready var portInput: LineEdit = $"%portInput"
@onready var launchBtn: Button = $"%launchBtn"
@onready var connectBtn: Button = $"%connectBtn"
@onready var maxPlayerInput: LineEdit = $"%maxPlayerInput"
@onready var connectionState: Label = $"%connectionState"

func _ready():
	diffEdit.min_value = GameRule.difficultyRange.x
	diffEdit.max_value = GameRule.difficultyRange.y
	startBtn.pressed.connect(
		func():
			Wave.next()
			UIState.closeCurrentPanel()
	)
	maxPlayerInput.text_changed.connect(
		func(text):
			MultiplayerState.maxPlayer = int(text)
	)
	launchBtn.pressed.connect(
		func():
			MultiplayerState.launchServer(int(portInput.text))
	)
	setState(MultiplayerState.ConnectionState.DISCONNECTED)
func _physics_process(_delta):
	levelShow.text = "%d ∈ [%d, %d]" % [diffEdit.value, diffEdit.min_value, diffEdit.max_value]
	GameRule.difficulty = diffEdit.value

func setState(state: MultiplayerState.ConnectionState):
	MultiplayerState.state = state
	connectionState.text = "状态：%s" % MultiplayerState.stateTextMap[state]
	connectionState.modulate = MultiplayerState.stateColorMap[state]
