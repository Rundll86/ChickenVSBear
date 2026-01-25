@tool
extends FullscreenPanelBase

@onready var diffEdit: HSlider = $"%diffEdit"
@onready var startSingleplayerBtn: Button = $"%startSingleplayerBtn"
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
var historyStack
@onready var serverConfig: VBoxContainer = $"%serverConfig"
@onready var players: VBoxContainer = $"%players"
@onready var playersList: VBoxContainer = $"%list"

@rpc("any_peer")
func mutexPlayer(player: String):
	if multiplayer.is_server():
		if getPlayerNames().count(player) > 1:
			var newName = player + str(randi_range(1000, 99999999999))
			setPlayerName.rpc(player, newName)
			setPlayerName(player, newName)
@rpc("any_peer")
func joinPlayer(player: String):
	if multiplayer.is_server():
		addPlayerName(player)
		rebuildAllPlayers.rpc(getPlayerNames())
		mutexPlayer(player)
@rpc("any_peer")
func leavePlayer(playerName: String):
	if multiplayer.is_server():
		removePlayerName(playerName)
		rebuildAllPlayers.rpc(getPlayerNames())
@rpc("any_peer")
func setPlayerName(oldName: String, newName: String):
	if playerNameInput.text == oldName:
		playerNameInput.text = newName
		historyStack[0].getData().append(newName)
	for i in playersList.get_children():
		if i.text == oldName:
			i.text = newName
			break
@rpc("any_peer")
func rebuildAllPlayers(playerNames: Array[String]):
	for i in playersList.get_children():
		i.queue_free()
	for i in playerNames:
		addPlayerName(i)
@rpc("any_peer")
func startMultiplayerGame():
	MultiplayerState.isMultiplayer = true
	MultiplayerState.playerName = playerNameInput.text
	MultiplayerState.connection = multiplayer.multiplayer_peer
	WorldManager.rootNode.multiplayer.multiplayer_peer = multiplayer.multiplayer_peer
	for i in getPlayerNames():
		EntityBase.generatePlayer(i)
	UIState.closeCurrentPanel()
func startSingleplayerGame():
	MultiplayerState.isMultiplayer = false
	MultiplayerState.playerName = playerNameInput.text
	EntityBase.generatePlayer(playerNameInput.text)
	WorldManager.rootNode.spawnWave(Vector2.ZERO)
	UIState.setPanel("CompilingTip")

func _ready():
	historyStack = Composables.useHistoryStack(playerNameInput)
	diffEdit.min_value = GameRule.difficultyRange.x
	diffEdit.max_value = GameRule.difficultyRange.y
	diffEdit.value = GameRule.difficulty
	multiplayer.connection_failed.connect(
		func():
			setState(MultiplayerState.ConnectionState.DISCONNECTED)
	)
	multiplayer.connected_to_server.connect(
		func():
			joinPlayer.rpc(playerNameInput.text)
			setState(MultiplayerState.ConnectionState.CONNECTED_CLIENT)
	)
	startSingleplayerBtn.pressed.connect(
		func():
			startSingleplayerGame()
	)
	startMultiplayerBtn.pressed.connect(
		func():
			startMultiplayerGame.rpc()
			startMultiplayerGame()
	)
	maxPlayerInput.text_changed.connect(
		func(text):
			MultiplayerState.maxPlayer = int(text)
	)
	launchBtn.pressed.connect(
		func():
			multiplayer.multiplayer_peer = MultiplayerState.launchServer(int(portInput.text))
			joinPlayer(playerNameInput.text)
			setState(MultiplayerState.ConnectionState.CONNECTED_HOST)
	)
	connectBtn.pressed.connect(
		func():
			multiplayer.multiplayer_peer = MultiplayerState.connectClient(hostInput.text, int(portInput.text))
			setState(MultiplayerState.ConnectionState.CONNECTING)
	)
	disconnectBtn.pressed.connect(
		func():
			leavePlayer.rpc(playerNameInput.text)
			setState(MultiplayerState.ConnectionState.DISCONNECTED)
	)
	var getLast = historyStack[1]
	playerNameInput.text_changed.connect(
		func(newText):
			setPlayerName.rpc(getLast.call(1), newText)
			setPlayerName(getLast.call(1), newText)
			mutexPlayer.rpc(newText)
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
	startMultiplayerBtn.disabled = not MultiplayerState.isConnected() || !multiplayer.is_server()
	serverConfig.visible = MultiplayerState.state == MultiplayerState.ConnectionState.CONNECTED_HOST
	players.visible = MultiplayerState.isConnected()
func addPlayerName(playerName: String):
	playersList.add_child(QuickUI.graySmallText(playerName))
func removePlayerName(playerName: String):
	for i in playersList.get_children():
		if i.text == playerName:
			i.queue_free()
func getPlayerNames() -> Array[String]:
	var result: Array[String] = []
	for i in playersList.get_children():
		result.append(i.text)
	return result
