extends Control



func _on_back_pressed() -> void:
	get_parent().get_parent().back_pressed_in_menu()


func _on_settings_pressed() -> void:
	get_parent().get_parent().settings_pressed()
