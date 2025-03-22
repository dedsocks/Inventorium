extends Node

# Constants
const MAX_SPEED = 10
const START_SPEED = 0.4
const CAM_START_POSITION = Vector2i(576, 324)
const START_POSITION = Vector2i(0, 300)

# Waste spawning components
var apple = preload("res://scenes/apple.tscn")
var sringe = preload("res://scenes/sringe.tscn")
var medicine = preload("res://scenes/medicine.tscn")
var bottle = preload("res://scenes/bottle.tscn")
var obstacleType = [apple, sringe, medicine, bottle]
var spawnPos = [500,600,700,800,900]
var obstacle = []
var f = 0 #flag for checking first item
var obs_x 

# Variables
var speed
var score
var gameRunning: bool
var screenSize: Vector2i
var lastObs
var groundHeight: int

func _ready():
	new_game()
	screenSize = get_window().size
	groundHeight = $ground.get_node("Sprite2D").texture.get_height()
	
	# Create a parent node for obstacles if it doesn't exist
	if not $Obstacles:
		var obstacle_container = Node2D.new()
		obstacle_container.name = "Obstacles"
		add_child(obstacle_container)

# Reset game parameters
func new_game():
	$dustbin.position = START_POSITION
	$Camera2D.position = CAM_START_POSITION
	speed = START_SPEED
	score = 0
	gameRunning = false
	obstacle.clear()

func _process(delta):
	if speed >= MAX_SPEED:
		speed = MAX_SPEED
		
	if Input.is_action_pressed("ui_accept"):
		gameRunning = true
	
	if gameRunning:
		$dustbin.position.x += speed
		$Camera2D.position.x += speed 
		speed += delta * 0.1  
		score = speed 
		
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
		var obs_y = 400  
		
		lastObs = obs
		spawn_obs(obs, obs_x, obs_y)

# Spawns obstacles
func spawn_obs(obs, x, y):
	obs.position = Vector2i(x, y)
	$Obstacles.add_child(obs)  
	obstacle.clear()
	f = 1

func spawnNum():
	var x = spawnPos[randi()%spawnPos.size()]
	return x
	
