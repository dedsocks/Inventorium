extends CharacterBody2D

var status : String

func _process(delta):
	
	#color change detector
	if Input.is_action_pressed("ui_down"):
		modulate = Color.DODGER_BLUE
		status = "BLUE"
	if Input.is_action_pressed("ui_right"):
		modulate = Color.RED
		status = "RED"
	if Input.is_action_pressed("ui_up"):
		modulate = Color.CHARTREUSE
		status = "GREEN"
	if Input.is_action_pressed("ui_left"):
		modulate = Color.YELLOW
		status = "YELLOW"
	
	
	move_and_slide()
