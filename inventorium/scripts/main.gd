extends Node
# Constants
const MAX_SPEED = 10
const START_SPEED = 0.4
const CAM_START_POSITION = Vector2i(576, 324)
const START_POSITION = Vector2i(0, 300)
# Waste spawning components
var apple = preload("res://scenes/apple.tscn")
var glove = preload("res://scenes/glove.tscn")
var medicine = preload("res://scenes/medicine.tscn")
var bottle = preload("res://scenes/bottle.tscn")
var obstacleType = [apple, glove, medicine, bottle]
var spawnPos = [500,600,700,800,900]
var obstacle = []
var f = 0 #flag for checking first item
var obs_x 
# Variables
var speed
var score
var highScore
var gameRunning: bool
var screenSize: Vector2i
var lastObs
var groundHeight: int

func _ready():
	screenSize = get_window().size
	groundHeight = $ground.get_node("Sprite2D").texture.get_height()
	
	# Create a parent node for obstacles if it doesn't exist
	if not $Obstacles:
		var obstacle_container = Node2D.new()
		obstacle_container.name = "Obstacles"
		add_child(obstacle_container)
	new_game()

# Reset game parameters
func new_game():
	$dustbin.position = START_POSITION
	$Camera2D.position = CAM_START_POSITION
	$dustbin.modulate = Color.DODGER_BLUE
	$dustbin.status = $dustbin.state.BLUE
	$ground.position = Vector2i(0,0)
	$HUD/gameOver.hide()
	$HUD/gameOverScore.hide()
	speed = START_SPEED
	score = 0
	f = 0
	obstacle.clear()
	$gameStart.play()

func _process(delta):
	if speed >= MAX_SPEED:
		speed = MAX_SPEED
			
	if gameRunning:
		$gameStart.stop()
		$HUD/highScore.show()
		$HUD/homeButton.show()
		$HUD/pauseButton.show()
		$startButton.hide()
		$HUD/menuButton.hide()
		$HUD/gameStart.hide()
		$dustbin/AnimatedSprite2D.play("move")
		$dustbin.position.x += speed
		$Camera2D.position.x += speed 
		assignScore()
		$HUD/Label.show()
		speed += delta * 0.1  
		
		if $gameRunningMusic.playing == false :
			$gameRunningMusic.play()
			
		# Code for shifting ground
		if $Camera2D.position.x - $ground.position.x > 1.5 * screenSize.x:
			$ground.position.x += screenSize.x
		
		generate_obs()

# Generates obstacles 
func generate_obs():
	if obstacle.is_empty() or ($Camera2D.position.x - lastObs.position.x > 300):
		var obsType = obstacleType.pick_random()  
		var obs = obsType.instantiate()
		obs_x = 1152 if f != 1 else obs_x + spawnNum()
		var obs_y = 345
		
		lastObs = obs
		spawn_obs(obs, obs_x, obs_y)

# Spawns obstacles
func spawn_obs(obs, x, y):
	obs.position = Vector2i(x, y)
	$Obstacles.add_child(obs)  
	f = 1

# Randomizes spawn distance
func spawnNum():
	var x = spawnPos[randi()%spawnPos.size()]
	return x

# Assigns score onto the HUD
func assignScore():
	if score < 10:
		$HUD/Label.text = "0" + str(score)
	else:
		$HUD/Label.text = str(score)

func gameOver():
	$HUD/retryButton.show()
	$HUD/endHomeButton.show()
	$HUD/highScore.hide()
	$HUD/pauseButton.hide()
	$HUD/homeButton.hide()
	$HUD/Label.hide()
	$HUD/gameOver.show()
	$HUD/gameOverScore.text = 'Highscore : '+'\nScore : ' + str(score) 
	$HUD/gameOverScore.show()
	if $dustbin/oof:
		$dustbin/oof.play()
	$gameRunningMusic.stop()
	# Stop movement
	gameRunning = false
	
	$dustbin/AnimatedSprite2D.stop()
	$dustbin/AnimatedSprite2D.play("death")
	await $dustbin/AnimatedSprite2D.animation_finished
	
	await get_tree().create_timer(0.5).timeout
	if $ending:
		$ending.play()
	await get_tree().create_timer(1.0).timeout
	get_tree().paused = true

# Buttons pressed 
func _on_start_button_pressed() -> void:
	gameRunning = true
	$gameStart.stop()

# Restarts game
func restart():
	get_tree().paused = false
	gameRunning = true
	
	if $Obstacles:
		for obs in $Obstacles.get_children():
			obs.queue_free()
	
	_ready()
