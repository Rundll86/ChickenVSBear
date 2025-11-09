class_name MultiplayerState

enum ConnectionState {
	DISCONNECTED,
	CONNECTING,
	CONNECTED_HOST,
	CONNECTED_CLIENT,
}
static var stateTextMap = {
	ConnectionState.DISCONNECTED: "未连接到服务器。",
	ConnectionState.CONNECTING: "连接中...",
	ConnectionState.CONNECTED_HOST: "服务器启动成功！",
	ConnectionState.CONNECTED_CLIENT: "已连接到服务器！",
}
static var stateColorMap = {
	ConnectionState.DISCONNECTED: Color.RED,
	ConnectionState.CONNECTING: Color.YELLOW,
	ConnectionState.CONNECTED_HOST: Color.GREEN,
	ConnectionState.CONNECTED_CLIENT: Color.GREEN,
}

static var state: ConnectionState = ConnectionState.DISCONNECTED
static var isMultiplayer: bool = false

static var maxPlayer: int = 10

static func launchServer(port: int):
	isMultiplayer = true
	var peer = ENetMultiplayerPeer.new()
	peer.create_server(port, maxPlayer)
	return peer
