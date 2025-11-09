@tool
extends FullscreenPanelBase

@onready var diffEdit: HSlider = $"%diffEdit"
@onready var startBtn: Button = $"%startBtn"
@onready var startMultiplayerBtn: Button = $"%startMultiplayerBtn"
@onready var levelShow: Label = $"%levelShow"
@onready var hostInput: LineEdit = $"%hostInput"
@onready var portInput: LineEdit = $"%portInput"
@onready var launchBtn: Button = $"%launchBtn"
@onready var connectBtn: Button = $"%connectBtn"
@onready var maxPlayerInput: LineEdit = $"%maxPlayerInput"
@onready var connectionState: Label = $"%connectionState"
@onready var disconnectBtn: Button = $"%disconnectBtn"
@onready var playerNameInput: LineEdit = $"%playerNameInput"
@onready var serverConfig: VBoxContainer = $"%serverConfig"

func _ready():
	diffEdit.min_value = GameRule.difficultyRange.x
	diffEdit.max_value = GameRule.difficultyRange.y
	multiplayer.connection_failed.connect(
		func():
			setState(MultiplayerState.ConnectionState.DISCONNECTED)
	)
	multiplayer.peer_connected.connect(
		func():
			setState(MultiplayerState.ConnectionState.CONNECTED_CLIENT)
	)
	startBtn.pressed.connect(
		func():
			EntityBase.generatePlayer(playerNameInput.text)
			Wave.next()
			UIState.closeCurrentPanel()
	)
	startMultiplayerBtn.pressed.connect(
		func():
			pass
	)
	maxPlayerInput.text_changed.connect(
		func(text):
			MultiplayerState.maxPlayer = int(text)
	)
	launchBtn.pressed.connect(
		func():
			MultiplayerState.launchServer(int(portInput.text))
			setState(MultiplayerState.ConnectionState.CONNECTED_HOST)
	)
	connectBtn.pressed.connect(
		func():
			multiplayer.multiplayer_peer = MultiplayerState.connectClient(hostInput.text, int(portInput.text))
			setState(MultiplayerState.ConnectionState.CONNECTING)
	)
	disconnectBtn.pressed.connect(
		func():
			setState(MultiplayerState.ConnectionState.DISCONNECTED)
	)
	setState(MultiplayerState.ConnectionState.DISCONNECTED)
func _physics_process(_delta):
	levelShow.text = "%d ∈ [%d, %d]" % [diffEdit.value, diffEdit.min_value, diffEdit.max_value]
	GameRule.difficulty = diffEdit.value

func setState(state: MultiplayerState.ConnectionState):
	MultiplayerState.state = state
	connectionState.text = "状态：%s" % MultiplayerState.stateTextMap[state]
	connectionState.modulate = MultiplayerState.stateColorMap[state]
	disconnectBtn.disabled = not MultiplayerState.isConnected()
	startMultiplayerBtn.disabled = not MultiplayerState.isConnected()
	serverConfig.visible = MultiplayerState.state == MultiplayerState.ConnectionState.CONNECTED_HOST
