extends Viewport
class_name ViewportPlus

func _ready():
	pass

func _notification(what):
	if what == Node.NOTIFICATION_WM_CLOSE_REQUEST and not get_tree().quitting:
		get_tree().quit_animated()
		return
