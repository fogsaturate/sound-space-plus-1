extends Node

# signal connected
signal disconnected

signal update_player_list

var clientusername : String
var mapid : String
var player_host : bool
var player_ready : bool

var connected : bool = false

var user_list : Dictionary

func _ready():
	get_tree().connect("connected_to_server", self, "_connected_ok") # called when someone connects to the server
	# get_tree().connect("server_disconnected", self, "_server_disconnected")

func host(port: int = 4927):
	var peer : NetworkedMultiplayerENet = NetworkedMultiplayerENet.new()
	peer.create_server(port,32)
	get_tree().network_peer = peer
	

func join(ip: String = "127.0.0.1", port: int = 4927):
	var peer : NetworkedMultiplayerENet = NetworkedMultiplayerENet.new()
	peer.create_client(ip, port)
	get_tree().network_peer = peer

var player_info : Dictionary = {} # other player's info
var client_info : Dictionary = { name = clientusername, player_map_selected = mapid, player_ready = false} # you, yourself as the client's info

func _connected_ok():
	print("connected to server")
	var compile_data : Array = [str(get_tree().get_network_unique_id()),clientusername]
	emit_signal("update_player_list")
	rpc_unreliable_id(1,"update_player",compile_data)

func _cleanup():
	multiplayer.multiplayer_peer = null
	player_info = {}

remote func update_player(user):
	user_list[str(user[0])] = user[1]
	emit_signal("update_player_list")
	rpc_unreliable("client_update",user_list)
	pass

remote func client_update(update_player_list):
	user_list = update_player_list
	emit_signal("update_player_list")