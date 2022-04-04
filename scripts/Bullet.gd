extends "res://scripts/CircularBody.gd"

# Global constant: bullet size
var bullet_radius: float = 24.0

# Called when the node enters the scene tree for the first time.
func _ready():
	set_radius(bullet_radius)
