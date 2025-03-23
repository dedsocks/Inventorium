extends CharacterBody2D

enum state {BLUE, RED, GREEN, YELLOW}
var status 

func _process(delta):
	
	#color change detector
	if Input.is_action_pressed("ui_down"):
		modulate = Color.DODGER_BLUE
		status = state.BLUE
	if Input.is_action_pressed("ui_right"):
		modulate = Color.RED
		status = state.RED
	if Input.is_action_pressed("ui_up"):
		modulate = Color.CHARTREUSE
		status = state.GREEN
	if Input.is_action_pressed("ui_left"):
		modulate = Color.YELLOW
		status = state.YELLOW
		
	
	
	
	move_and_slide()

#obstacle and dustbin collision checker
func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("blue_waste"):
		if status == state.BLUE :
			get_parent().score += 1
			print(get_parent().score)
		else :
			get_parent().gameOver()
	if area.is_in_group("red_waste"):
		if status == state.RED :
			get_parent().score += 1
			print(get_parent().score)
		else :
			get_parent().gameOver()
	if area.is_in_group("green_waste"):
		if status == state.GREEN :
			get_parent().score += 1
			print(get_parent().score)
		else :
			get_parent().gameOver()
	if area.is_in_group("yellow_waste"):
		if status == state.YELLOW :
			get_parent().score += 1
			print(get_parent().score)
		else :
			get_parent().gameOver()
	
			
