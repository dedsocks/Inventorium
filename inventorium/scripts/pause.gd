extends Control

func _on_resume_pressed():
	get_parent().get_parent().resume()
	


func _on_restart_pressed():
	get_parent().get_parent().restart()
	self.visible = false



func _on_menu_pressed() -> void:
	get_parent().get_parent().menu_pressed()
