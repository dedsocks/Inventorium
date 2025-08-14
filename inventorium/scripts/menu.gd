extends Control



func _on_back_pressed() -> void:
	get_parent().get_parent().back_pressed_in_menu()


func _on_settings_pressed() -> void:
	get_parent().get_parent().settings_pressed()


func _on_tutorial_pressed() -> void:
	$AudioStreamPlayer2D.play()
	get_parent().get_parent().show_tutorial()
	
	
	
	
