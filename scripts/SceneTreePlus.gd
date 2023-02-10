extends SceneTree
class_name SceneTreePlus

var fps_limit:int = 0

func _init():
	OS.set_window_title("Sound Space Plus Rewritten")
	OS.min_window_size = Vector2(512,512)
	OS.center_window()
	._init()

func _is_game_scene(scene):
	return current_scene is GameScene
func _idle(delta):
	var fps = 90
	if _is_game_scene(current_scene):
		fps = fps_limit
	elif fps_limit != 0:
		fps = min(fps_limit,90)
	if !OS.is_window_focused():
		fps = 30
	Engine.target_fps = fps

var quitting = false
func _set_master_volume(volume_db:float):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Sound Space Plus"),volume_db)
func quit(exit_code:int=0):
	if quitting:
		return
	quitting = true
	var viewport = root
	var container = ViewportContainer.new()
	var fakeport = Viewport.new()
	fakeport.size = viewport.size
	container.add_child(fakeport)
	container.anchor_top = 0
	container.anchor_left = 0
	container.anchor_bottom = 1
	container.anchor_right = 1
	container.margin_top = 0
	container.margin_left = 0
	container.margin_bottom = 0
	container.margin_right = 0
	viewport.add_child(container)
	var scene = current_scene
	viewport.remove_child(scene)
	fakeport.add_child(scene)
	viewport.transparent_bg = true
	var voice_player = AudioStreamPlayer.new()
	voice_player.bus = "Awesome!"
	var voice = preload("res://assets/sounds/death.mp3") as AudioStream
	voice_player.stream = voice
	viewport.add_child(voice_player)
	voice_player.play()
	var tween = Tween.new()
	viewport.add_child(tween)
	tween.interpolate_property(container,"modulate:a",1,0,1.5,Tween.TRANS_SINE,Tween.EASE_IN_OUT)
	tween.interpolate_method(self,"_set_master_volume",linear2db(1),linear2db(0),0.5,Tween.TRANS_EXPO,Tween.EASE_OUT)
	tween.start()
	print("Quitting!")
	yield(tween,"tween_all_completed")
	.quit(exit_code)
func _notification(what):
	if what == NOTIFICATION_WM_QUIT_REQUEST and not quitting:
		quit()
		return
