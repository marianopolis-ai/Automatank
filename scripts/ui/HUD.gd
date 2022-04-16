extends CanvasLayer

# Relay signals
signal start_game
signal start_test
signal clear_game

func _return_home():
	$PauseButton.hide()
	$PauseMenu.hide()
	$GameOver.hide()
	
	$MainMenu.show()
	
	emit_signal("clear_game")


func _quit_game():
	pass # Replace with function body.


func _resume_game():
	var game_world = get_parent().game_world
	# The game can only be unpaused if it has started already.
	if game_world:
		if game_world.game_started:
			# Unpause the game
			get_tree().paused = false
	else:
		# The game can be freely unpaused in test mode.
		get_tree().paused = false

	# Hide the pause menu.
	$PauseMenu.hide()


func _pause():
	# Pause the game
	get_tree().paused = true
	# Show the pause menu.
	$PauseMenu.show()


func _show_game_over_screen(winner: String):
	$GameOver.show()
	$GameOver.update_label(winner)


func _open_manual():
	pass # Replace with function body.


func _start_game():
	$MainMenu.hide()
	$PauseButton.show()
	
	emit_signal("start_game")


func _start_test():
	$MainMenu.hide()
	$PauseButton.show()
	
	emit_signal("start_test")


func display_error(error: String):
	# Set the label's text as the error.
	$ErrorContainer/ErrorLabel.text = "Error: " + error
	# Then show the container.
	$ErrorContainer.show()
	
	# Wait for 5 seconds.
	yield(get_tree().create_timer(5.0), "timeout")
	# Then hide the container.
	$ErrorContainer.hide()
