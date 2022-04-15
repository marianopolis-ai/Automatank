extends Node2D


var script_tank_scene = preload("res://ScriptControlledTank.tscn")


func _ready():
	print("event attached")
	# Receive file drop events.
	get_tree().connect("files_dropped", self, "_receive_files_dropped")


func _receive_files_dropped(file_paths: PoolStringArray, _screen: int):
	for file_path in file_paths:
		print(file_path)
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
		
		add_child(tank)
