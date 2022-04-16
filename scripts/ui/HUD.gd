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
	# Unpause the game
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
