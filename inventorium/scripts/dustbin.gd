extends CharacterBody2D

enum state {BLUE, RED, GREEN, YELLOW}
var status 

func colorChange(temp):
	status = temp
	if status == 0:
		modulate = Color.DODGER_BLUE
	if status == 1:
		modulate = Color.RED
	if status == 2:
		modulate = Color.GREEN
	if status == 3:
		modulate = Color.YELLOW

#obstacle and dustbin collision checker
func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("blue_waste"):
		if status == state.BLUE :
			get_parent().score += 1
			area.hide()
			$eat.play()
		else :
			area.hide()
			deathCall()
	if area.is_in_group("red_waste"):
		if status == state.RED :
			get_parent().score += 1
			area.hide()
			$eat.play()
		else :
			area.hide()
			deathCall()
	if area.is_in_group("green_waste"):
		if status == state.GREEN :
			get_parent().score += 1
			area.hide()
			$eat.play()
		else :
			area.hide()
			deathCall()
	if area.is_in_group("yellow_waste"):
		if status == state.YELLOW :
			get_parent().score += 1
			area.hide()
			$eat.play()
		else :
			area.hide()
			deathCall()

func deathCall():
	get_parent().gameOver()
			
