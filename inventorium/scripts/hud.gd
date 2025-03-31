extends CanvasLayer

func _on_retry_button_pressed() -> void:
	var nodes_in_group = get_tree().get_nodes_in_group("endButtons")
	
	for node in nodes_in_group:
		node.hide()
	
	get_parent().restart()
	
