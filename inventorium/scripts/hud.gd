extends CanvasLayer

func _on_retry_button_pressed() -> void:
	click()
	var nodes_in_group = get_tree().get_nodes_in_group("endButtons")
	
	for node in nodes_in_group:
		node.hide()
	
	get_parent().restart()
	
func _on_end_home_button_pressed() -> void:
	click()
	get_parent().home()

func _on_home_button_pressed() -> void:
	click()
	get_parent().home()

func _on_red_button_pressed() -> void:
	get_parent().signalPasser(1)

func _on_yellow_button_pressed() -> void:
	get_parent().signalPasser(3)

func _on_blue_button_pressed() -> void:
	get_parent().signalPasser(0)

func _on_green_button_pressed() -> void:
	get_parent().signalPasser(2)

func click():
	$buttonSound.play()


func _on_pause_button_pressed() -> void:
	click()
	get_parent().pause()


func _on_menu_button_pressed() -> void:
	click()
	get_parent().menu_pressed()
