extends ColorRect


# Declare member variables here. Examples:
# var a = 2
var connected : bool = false

onready var username = $MultiplayerWindow/UsernameText
onready var ip = $MultiplayerWindow/IPText
onready var port = $MultiplayerWindow/PortText

onready var host = $MultiplayerWindow/Host
onready var join = $MultiplayerWindow/Join

onready var multiplayerwindow = $MultiplayerWindow
onready var chatwindow = $ChatWindow

onready var messagebox = $ChatWindow/MessageBox
onready var sendmessagetext = $ChatWindow/SendMessageText

var clientusername : String
var clientmessage : String

# Called when the node enters the scene tree for the first time.
func _ready():
	# if connected == true:
	# 	multiplayerwindow.hide()
	# 	chatwindow.show()
	# else:
	# 	multiplayerwindow.show()
	# 	chatwindow.hide()
	pass



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Host_pressed():
	var peer = NetworkedMultiplayerENet.new()
	peer.create_server(int(port.text),32)
	get_tree().network_peer = peer
	joined()

func _on_Send_pressed():
	rpc_unreliable("sendmsg_rpc", create_message())
	messagebox.text += create_message()
	# sendmsg_rpc(create_message())
	sendmessagetext.text = ""
	# sendmsg_test(sendmessagetext.text)

func create_message() -> String:
	return clientusername + ": " + sendmessagetext.text + "\n"

func _on_Join_pressed():
	var peer = NetworkedMultiplayerENet.new()
	peer.create_client(ip.text, int(port.text))
	get_tree().network_peer = peer
	joined()

remote func sendmsg_rpc(message):
	messagebox.text += str(message)
	print("received!")
# remote func sendmsg_rpc(message):
# 	messagebox.text += str(message, "\n")
	

func joined():
	multiplayerwindow.hide()
	chatwindow.show()
	clientusername = username.text
	connected = true

