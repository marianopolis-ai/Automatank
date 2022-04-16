extends Control

# Relay signals
signal start_game
signal start_test
signal open_manual


func _start_game():
	emit_signal("start_game")


func _start_test():
	emit_signal("start_test")


func _open_manual():
	emit_signal("open_manual")
