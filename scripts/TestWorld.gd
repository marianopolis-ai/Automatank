extends Node2D

# Setup the tank scenes.
var script_tank_scene = preload("res://scenes/ScriptControlledTank.tscn")
var player_tank_scene = preload("res://scenes/PlayerControlledTank.tscn")
var tank_scene = preload("res://scenes/Tank.tscn")

# Have an RNG for the scene.
var rng = RandomNumberGenerator.new()


# Relay errors.
signal script_error


func _ready():
	# Randomise the RNG.
	rng.randomize()
	
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
		
		var tank = script_tank_scene.instance()
		# Attach the script to the tank.
		tank.script_source = file_content
		# Put it where the mouse is.
		tank.set_position(get_global_mouse_position() - position)
		
		# Connect the tank's error signal to this.
		tank.connect("script_error", self, "_receive_script_error")
		
		add_child(tank)
	
	# Hide the tip image upon receiving a file drop.
	$TipImageHolder/TipImage.hide()


func _receive_script_error(tank, error):
	# Immediately remove the tank.
	tank.queue_free()
	# And emit the error.
	emit_signal("script_error", error)


func _spawn_dummy():
	var tank = tank_scene.instance()
	
	tank.set_name("Dummy")
	# Give it a random colour
	tank.inner_circle_colour = Color(rng.randf(), rng.randf(), rng.randf())
	
	# Send the tank off to a random position.
	tank.apply_central_impulse(Vector2.RIGHT.rotated(rng.randf_range(0, 2 * PI)) * rng.randf_range(500, 1500))
	
	
	# And attach it to the world.
	add_child(tank)


func _spawn_player():
	# Simply instance and add the player to the scene.
	add_child(player_tank_scene.instance())


func _kill_all():
	for tank in get_tree().get_nodes_in_group("tank"):
		# Add overlap to every tank to quickly drain their health.
		tank.overlap_count += 3
