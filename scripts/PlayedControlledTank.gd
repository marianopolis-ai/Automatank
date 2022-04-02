extends "res://scripts/Tank.gd"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Nothing happening here yet.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Update the tank's orientation based on the player's mouse position.
	cannon_orientation = (get_global_mouse_position() - position).angle()
	
	get_input()


func get_input():
	if Input.is_action_pressed("left"):
		accelerate(Vector2(-1, 0))
	if Input.is_action_pressed("right"):
		accelerate(Vector2(1, 0))
	if Input.is_action_pressed("up"):
		accelerate(Vector2(0, -1))
	if Input.is_action_pressed("down"):
		accelerate(Vector2(0, 1))
