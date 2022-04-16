extends Node2D

# Preload the scenes
var test_world_scene = preload("res://scenes/TestWorld.tscn")
var game_world_scene = preload("res://scenes/GameWorld.tscn")

var test_world = null
var game_world = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _start_game():
	# Create a game world.
	game_world = game_world_scene.instance()
	
	# Connect the game over signal to show the game over screen.
	game_world.connect("game_over", $HUD, "_show_game_over_screen")
	
	# And attach it to the node.
	add_child(game_world)


func _start_test():
	# Create a test world.
	test_world = test_world_scene.instance()
	# And attach it to the node.
	add_child(test_world)


func _clear_game():
	# Remove any worlds from the scene.
	if test_world:
		test_world.queue_free()
		test_world = null
	if game_world:
		game_world.queue_free()
		
		# Disconnect the game over signal.
		game_world.disconnect("game_over", $HUD, "_show_game_over_screen")
		
		game_world = null
