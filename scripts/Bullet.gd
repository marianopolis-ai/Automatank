extends "res://scripts/CircularBody.gd"

var base_bullet_health = 40
var bullet_radius = 16

# Called when the node enters the scene tree for the first time.
func _ready():
	set_max_health(base_bullet_health)
	set_radius(bullet_radius)
