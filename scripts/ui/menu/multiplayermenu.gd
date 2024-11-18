extends ColorRect

onready var username = $MultiplayerWindow/UsernameText
onready var ip = $MultiplayerWindow/IPText
onready var port = $MultiplayerWindow/PortText

onready var host = $MultiplayerWindow/Host
onready var join = $MultiplayerWindow/Join

onready var multiplayerwindow = $MultiplayerWindow
onready var chatwindow = $ChatWindow

onready var messagebox = $ChatWindow/MessageBox
onready var sendmessagetext = $ChatWindow/SendMessageText

onready var userlist = $ChatWindow/UserList

func _ready():
	Multiplayer.connect("update_player_list",self,"update_player_list")
	
	# if we're server just update list
	if(Multiplayer.connected == true): 
		joined()
	pass


func _on_Host_pressed():
	Multiplayer.host()
	Multiplayer.clientusername = username.text
	Multiplayer.user_list[str(get_tree().get_network_unique_id())] = Multiplayer.clientusername
	print(Multiplayer.user_list)
	joined()

func _on_Join_pressed():
	Multiplayer.join()
	Multiplayer.clientusername = username.text
	joined()

func _on_Send_pressed():
	rpc("sendmsg_rpc", create_message())
	messagebox.text += create_message()
	# sendmsg_rpc(create_message())
	sendmessagetext.text = ""
	# sendmsg_test(sendmessagetext.text)

func _on_StartButton_pressed():
	rpc("startMap_rpc")
	get_viewport().get_node("Menu").black_fade_target = true
	yield(get_tree().create_timer(0.35),"timeout")
	get_tree().change_scene("res://scenes/loaders/songload.tscn")

puppet func startMap_rpc():
	print("trying to start map now!")
	if !Rhythia.selected_song: return
	print("selected song has been returned!")
	get_viewport().get_node("Menu").black_fade_target = true
	print("menu has faded out!")
	yield(get_tree().create_timer(0.35),"timeout")
	print("timer has been created!")
	get_tree().change_scene("res://scenes/loaders/songload.tscn")
	print("scene has been swapped!")

func create_message() -> String:
	return Multiplayer.clientusername + ": " + sendmessagetext.text + "\n"

func update_player_list():
	userlist.clear()
	for i in Multiplayer.user_list:
		# var data = Multiplayer.user_list[i]
		userlist.add_item(Multiplayer.user_list[i])
	

remote func sendmsg_rpc(message):
	messagebox.text += str(message)
	print("received!")
# remote func sendmsg_rpc(message):
# 	messagebox.text += str(message, "\n")
	

func joined():
	multiplayerwindow.hide()
	chatwindow.show()
	print(Multiplayer.clientusername)
	update_player_list()
	Multiplayer.connected = true
	Multiplayer.mapid = Rhythia.selected_song.song
	print(Multiplayer.mapid)



