extends LineEdit

func update_txt(_v=null):
	get_parent().get_parent().get_node("S/VBoxContainer").update_search_text(text)
	Rhythia.last_search_str = text

func _ready():
	connect("text_changed",self,"update_txt")
	text = Rhythia.last_search_str
	update_txt()
	get_parent().get_parent().get_node("S/VBoxContainer").connect("reset_filters",self,"_on_reset_filters")
	get_parent().get_parent().get_node("S/VBoxContainer").connect("lock_type",self,"_on_lock_type")
	get_parent().get_parent().get_parent().get_node("Results/Results/RS/H1/Info/Run").connect("lock_type",self,"_on_lock_type")

func _on_reset_filters():
	text = ""
	update_txt()

func _on_lock_type():
	#prevent input
	set_editable(false)

func _input(event): # any unicode input starts search
	# remain the ability to type in other textboxes i wonder if you can tell if type focus is happening
	if get_focus_owner() == self: return
	if get_focus_owner() == $"/root/Menu/Main/Maps/MapRegistry/T/AuthorSearch": return
	if get_focus_owner() == $"/root/Menu/Main/Maps/Results/Results/RS/H2/Mods/SpeedMod/C/CustomSpeed".get_line_edit(): return
	if get_focus_owner() == $"/root/Menu/Main/Maps/Results/Results/RS/H2/Mods/StartOffset/TimeTextBox": return
	
	if not is_visible_in_tree(): return
	if event is InputEventKey and event.is_pressed():
		#if space return so you can use space to play map
		if event.scancode == KEY_SPACE: return
		if event.scancode == KEY_BACKSPACE:
			if len(text) == 0: return
			else: 
				clear()
				grab_focus()
		var unicode = event.get_unicode()
		if unicode != 0:
			grab_focus()
			
