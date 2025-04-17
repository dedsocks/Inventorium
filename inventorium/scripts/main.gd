extends Node

# Constants
const MAX_SPEED = 900
const START_SPEED = 330
const CAM_START_POSITION = Vector2i(576, 324)
const START_POSITION = Vector2i(93, 300)

# Waste spawning components
var apple = preload("res://scenes/apple.tscn")
var glove = preload("res://scenes/glove.tscn")
var medicine = preload("res://scenes/medicine.tscn")
var bottle = preload("res://scenes/bottle.tscn")
var obstacleType = [apple, glove, medicine, bottle]
var spawnPos = [500, 600, 700, 800, 900]
var obstacle = []
var f = 0 #flag for checking first item
var obs_x 

# Variables
var speed
var score
var highScore
var gameRunning: bool = false
var screenSize: Vector2i
var lastObs
var groundHeight: int
var groundWidth: int
var message

func _ready():
	screenSize = get_window().size
	groundHeight = $ground.get_node("Sprite2D").texture.get_height()
	groundWidth = $ground.get_node("Sprite2D").texture.get_width()
	
	if not has_node("Obstacles"):
		var obstacle_container = Node2D.new()
		obstacle_container.name = "Obstacles"
		add_child(obstacle_container)
		
	new_game()

func reset_game_state():
	get_tree().paused = false
	$dustbin.position = START_POSITION
	$Camera2D.position = CAM_START_POSITION
	$dustbin.modulate = Color.DODGER_BLUE
	$dustbin.status = $dustbin.state.BLUE
	$ground.position = Vector2i(0, 0)
	
	speed = START_SPEED
	score = 0
	f = 0
	gameRunning = false

	obstacle.clear()
	if has_node("Obstacles"):
		for obs in $Obstacles.get_children():
			obs.queue_free()

# Set up UI for game start
func update_ui_for_menu():
	$gameStart.stop()
	$HUD/gameOver.hide()
	$HUD/gameOverScore.hide()
	$HUD/highScore.hide()
	$HUD/homeButton.hide()
	$HUD/pauseButton.hide()
	$HUD/Label.hide()
	$HUD/retryButton.hide()
	$HUD/endHomeButton.hide()
	
	$startButton.show()
	$HUD/menuButton.show()
	$HUD/gameStart.show()
	
	var buttons = $HUD.get_tree().get_nodes_in_group("colorButtons")
	
	for button in buttons:
		button.hide()

func new_game():
	reset_game_state()
	update_ui_for_menu()
	$gameStart.play()

func _process(delta):
	
	if not gameRunning:
		crow_mover(delta)
		return
		
	if speed >= MAX_SPEED:
		speed = MAX_SPEED
			
	speed += delta*1.8*(1+(score/20.0))
	
	$dustbin/AnimatedSprite2D.play("move")
	$dustbin.position.x += speed*delta
	$Camera2D.position.x += speed*delta
	
	assignScore()
	

	if not $gameRunningMusic.playing:
		$gameRunningMusic.play()
		
	# Code for shifting ground
	if $Camera2D.position.x - $ground.position.x > 1.5 * screenSize.x:
		$ground.position.x += screenSize.x
	
	generate_obs()

# Generate obstacles 
func generate_obs():
	if obstacle.is_empty() or (lastObs and $Camera2D.position.x - lastObs.position.x > 300):
		var obsType = obstacleType.pick_random()  
		var obs = obsType.instantiate()
		obs_x = 1152 if f != 1 else obs_x + spawnNum()
		var obs_y = 345
		
		lastObs = obs
		spawn_obs(obs, obs_x, obs_y)

# Spawn obstacles
func spawn_obs(obs, x, y):
	obs.position = Vector2i(x, y)
	$Obstacles.add_child(obs)  
	f = 1

# Randomize spawn distance
func spawnNum():
	var x = spawnPos[randi() % spawnPos.size()]
	return x

# Assigns score to HUD
func assignScore():
	if score < 10:
		$HUD/Label.text = "0" + str(score)
	else:
		$HUD/Label.text = str(score)

func gameOver():
	# Game over UI display
	$HUD/retryButton.show()
	$HUD/endHomeButton.show()
	$HUD/highScore.hide()
	$HUD/pauseButton.hide()
	$HUD/homeButton.hide()
	$HUD/Label.hide()
	$HUD/gameOver.show()
	$HUD/gameOverScore.text = 'Highscore : ' + '\nScore : ' + str(score) 
	$HUD/gameOverScore.show()
	
	if $dustbin/oof:
		$dustbin/oof.play()
	$gameRunningMusic.stop()
	
	gameRunning = false
	
	$dustbin/AnimatedSprite2D.stop()
	$dustbin/AnimatedSprite2D.play("death")
	await $dustbin/AnimatedSprite2D.animation_finished
	
	# To cause a delay before the game ends so sound effect can be completed
	await get_tree().create_timer(0.5).timeout
	if $ending:
		$ending.play()
	await get_tree().create_timer(1.0).timeout
	

func _on_start_button_pressed() -> void:
	$HUD.click()
	$gameStart.stop()
	await ready_set_go()
	start_gameplay()

func ready_set_go():
	#display color buttons
	var buttons = $HUD.get_tree().get_nodes_in_group("colorButtons")
	
	for button in buttons:
		button.show()
	
	# UI interface
	$startButton.hide()
	$HUD/menuButton.hide()
	$HUD/gameStart.hide()
	$HUD/READY.show()
	$HUD/beep.play()
	
	# Ready set go creator
	await get_tree().create_timer(1.0).timeout
	$HUD/READY.hide()
	$HUD/SET.show()
	$HUD/beep.play()
	await get_tree().create_timer(1.0).timeout
	$HUD/SET.hide()
	$"HUD/GO!!".show()
	$HUD/beep.play()
	await get_tree().create_timer(1.0).timeout
	$"HUD/GO!!".hide()
	
# Function to start gameplay
func start_gameplay():
	$HUD/highScore.show()
	$HUD/homeButton.show()
	$HUD/pauseButton.show()
	$startButton.hide()
	$HUD/menuButton.hide()
	$HUD/gameStart.hide()
	$HUD/Label.show()
	
	gameRunning = true

func restart():
	if has_node("Obstacles"):
		for obs in $Obstacles.get_children():
			obs.queue_free()

	reset_game_state()
	$dustbin/AnimatedSprite2D.play("idle")
	await ready_set_go()
	start_gameplay()

# Vardans code 
func _on_pause_button_pressed():
	pass

# Vardans code 
func _on_resume_button_pressed():
	pass

# Vardans code 
func _on_menu_button_pressed():
	pass

func home():
	$dustbin/AnimatedSprite2D.play("idle")
	if $gameRunningMusic.playing:
		$gameRunningMusic.stop()

	reset_game_state()

	update_ui_for_menu()

	if $gameStart and not $gameStart.playing:
		$gameStart.play()

func signalPasser(message):
	$dustbin.colorChange(message)

func crow_mover(delta):
	if $crow.position.x >=-50:
		$crow.position.x -= 200*delta
		$crow2.position.x -= 200*delta
	else:
		$crow.position.x = 1182
		$crow2.position.x = 1237
		
