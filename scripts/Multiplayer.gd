extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

signal connected
signal disconnected

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	get_tree().connect("connected_to_server", self, "_connected_ok")
	get_tree().connect("connection_failed", self, "_connected_fail")
	get_tree().connect("server_disconnected", self, "_server_disconnected")

func host(port: int = 4927):
	var peer : NetworkedMultiplayerENet = NetworkedMultiplayerENet.new()
	peer.create_server(port,32)
	get_tree().network_peer = peer

func join(ip: String = "127.0.0.1", port: int = 4927):
	var peer : NetworkedMultiplayerENet = NetworkedMultiplayerENet.new()
	peer.create_client(ip, port)
	get_tree().network_peer = peer

var player_info : Dictionary = {} # other player's info
var client_info : Dictionary = {} # you, yourself as the client's info (you need to make your own info in godot 3 for some reason)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
