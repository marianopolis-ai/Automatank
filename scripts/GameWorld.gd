extends Node2D

# Setup the tank scenes.
var script_tank_scene = preload("res://scenes/ScriptControlledTank.tscn")

# Variables used to spawn tanks.
var anchors = []
var tanks_count: int = 0
var game_started = false

# Checks for winner every second.
var check_cooldown: float = 0

onready var instruction_label = $StartingInstructions/CenterContainer/InstructionLabel

signal game_over

func _ready():
	# The game world starts paused, waiting for tanks to be dragged in.
	# The game will resume when all spots are filled.
	get_tree().paused = true
	
	# Obtain all the anchors
	anchors = get_tree().get_nodes_in_group("anchor")
	
	# Receive file drop events.
	get_tree().connect("files_dropped", self, "_receive_files_dropped")


func _receive_files_dropped(file_paths: PoolStringArray, _screen: int):
	for file_path in file_paths:
		# Load the file from the given path.
		var file = File.new()
		file.open(file_path, File.READ)
		
		# Fetch the file's content.
		var file_content = file.get_as_text()
		file.close()
		
		# Then add the tank to the scene.
		add_tank(file_content)


# Adds a tank to the scene.
func add_tank(script_source: String):
	var tank = script_tank_scene.instance()
	# Attach the script to the tank.
	tank.script_source = script_source
	
	# Put it at the next anchor.
	tank.set_position(anchors[tanks_count].position)
	
	# Then append the tank.
	add_child(tank)
	
	# Increment the number of tanks and update the label.
	tanks_count += 1
	instruction_label.text = "Drag %s TankController files into the window to start the game." % (anchors.size() - tanks_count)
	
	# If enough tanks are in the game, start the game.
	if tanks_count == anchors.size():
		get_tree().paused = false
		# Remove the label.
		instruction_label.queue_free()
		
		game_started = true


func _process(delta):
	check_cooldown -= delta
	if check_cooldown < 0:
		var tanks = get_tree().get_nodes_in_group("tank")
		
		# If only one is living.
		if tanks.size() == 1:
			# Emits the game over signal with the winner's name.
			emit_signal("game_over", tanks[0].tank_name)
		
		check_cooldown = 1
