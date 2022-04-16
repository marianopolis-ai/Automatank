extends Control

# Relay signals
signal home

onready var message_label = $CenterContainer/PanelContainer/VBoxContainer/Message

func _home():
	emit_signal("home")


func update_label(winner: String):
	message_label.text = "%s won!" % winner
