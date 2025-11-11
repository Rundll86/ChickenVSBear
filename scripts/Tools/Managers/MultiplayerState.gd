@tool
class_name MultiplayerState

enum ConnectionState {
	DISCONNECTED,
	CONNECTING,
	CONNECTED_HOST,
	CONNECTED_CLIENT,
}
static var stateTextMap = {
	ConnectionState.DISCONNECTED: "未连接到服务器。",
	ConnectionState.CONNECTING: "正在连接到服务器...",
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
static var playerName: String

static var maxPlayer: int = 10

static func isConnected():
	return [ConnectionState.CONNECTED_HOST, ConnectionState.CONNECTED_CLIENT].has(state)
static func launchServer(port: int) -> ENetMultiplayerPeer:
	var peer = ENetMultiplayerPeer.new()
	peer.create_server(port, maxPlayer)
	state = ConnectionState.CONNECTED_HOST
	return peer
static func connectClient(host: String, port: int) -> ENetMultiplayerPeer:
	var peer = ENetMultiplayerPeer.new()
	peer.create_client(host, port)
	state = ConnectionState.CONNECTED_CLIENT
	return peer
