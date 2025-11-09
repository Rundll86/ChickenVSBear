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
@onready var playersList: VBoxContainer = $"%list"

@rpc("any_peer")
func joinPlayer(player: String):
	playersList.add_child(QuickUI.graySmallText(player))
@rpc("any_peer")
func setPlayerName(oldName: String, newName: String):
	for i in playersList.get_children():
		if i.text == oldName:
			i.text = newName

func _ready():
	diffEdit.min_value = GameRule.difficultyRange.x
	diffEdit.max_value = GameRule.difficultyRange.y
	multiplayer.connection_failed.connect(
		func():
			setState(MultiplayerState.ConnectionState.DISCONNECTED)
	)
	multiplayer.connected_to_server.connect(
		func():
			joinPlayer.rpc(playerNameInput.text)
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
			multiplayer.multiplayer_peer = MultiplayerState.launchServer(int(portInput.text))
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
	playerNameInput.text_changed.connect(
		func(text):
			setPlayerName.rpc(playerNameInput.text, text)
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
