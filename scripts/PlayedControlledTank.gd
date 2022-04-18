extends "res://scripts/Tank.gd"


# Called when the node enters the scene tree for the first time.
func _ready():
	set_name("Player")
	apply_upgrades()
	
	# All player tanks have the same damage group.
	damage_group = 0


# Use the points to upgrade the tank.
func apply_upgrades():
	movement_strength *= 2
	bullet_speed *= 2
	bullet_health *= 2
	tank_max_health *= 2
	# Update accordingly
	set_max_health(tank_max_health)
	regen *= 2
	bullet_cooldown *= 0.5


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	clear_acceleration()
	
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
	if Input.is_action_just_pressed("shoot"):
		shoot((get_global_mouse_position() - position).angle())
