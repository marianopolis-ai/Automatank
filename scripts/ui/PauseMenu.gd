extends Control

# The menu script receives and relays signals to the main HUD node.
signal resume
signal home
signal quit


func _resume():
	emit_signal("resume")


func _home():
	emit_signal("home")


func _quit():
	emit_signal("quit")
