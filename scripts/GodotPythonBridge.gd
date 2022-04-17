extends "res://scripts/Tank.gd"

# The Godot Python Bridge uses signals to transmit information to and from the
# python script.
# This is because Godot and Python script files cannot inherit each other. 
# However, with this structure, it is possible for us to seal the python script
# off of Godot interface (so long as they don't choose to import stuff) as a
# direct consequence of using signals.

# Signal sent when initialising the python script.
signal initialise_script
# Signal sent when the tank updates.
signal tank_update
# Signal sent to relay errors caused by the script with arguments (tank, error).
signal script_error

# ------ Upgrade Factors ------
# A given stat is multiplied by the factor once per each point spent on that skill.
# Currently, these numbers are picked such that spending 1 point improves the
# stat by 15% and spending 5 improves the stat by 100%, the inverse applies for
# bullet cooldown.
var tank_speed_upgrade_factor: float = 1.15
var bullet_speed_upgrade_factor: float = 1.2
var bullet_health_upgrade_factor: float = 1.2
var tank_health_upgrade_factor: float = 1.15
var regen_upgrade_factor: float = 1.25
# Bullet cooldown has <1 factor because reducing cooldown is beneficial.
var bullet_cooldown_factor: float = 0.87


# ------ Points ------
var tank_speed_points: int = 0
var bullet_speed_points: int = 0
var tank_health_points: int = 0
var bullet_health_points: int = 0
var regen_points: int = 0
var bullet_cooldown_points: int = 0


# ----- Script-Related -----
var script_source: String = ""
# The script gets updated every 0.1 seconds.
var remaining_update_cooldown: float = 0.0
var update_cooldown: float = 0.1


# Called when the node enters the scene tree for the first time.
func _ready():
	# Request the python script to spend the skill points.
	emit_signal("initialise_script", script_source)


# Called when the node updates.
func _process(delta: float):
	remaining_update_cooldown -= delta
	if remaining_update_cooldown < 0.0:
		remaining_update_cooldown = update_cooldown
		# Request the tank to update as well.
		clear_acceleration()
		emit_signal("tank_update")


# Signal triggered when the python script finishes spending skill points
# and configuring the tank.
func _on_script_initialisation_complete(tsp, bsp, thp, bhp, rp, bcp, hc, n):	
	# Copy the stats
	tank_speed_points = tsp
	bullet_speed_points = bsp
	bullet_health_points = bhp
	tank_health_points = thp
	regen_points = rp
	bullet_cooldown_points = bcp
	
	# Apply the upgrades
	apply_upgrades()
	
	inner_circle_colour = Color(hc)
	
	set_name(n)


# Use the points to upgrade the tank.
func apply_upgrades():
	movement_strength *= pow(tank_speed_upgrade_factor, tank_speed_points)
	bullet_speed *= pow(bullet_speed_upgrade_factor, bullet_speed_points)
	bullet_health *= pow(bullet_health_upgrade_factor, bullet_health_points)
	tank_max_health *= pow(tank_health_upgrade_factor, tank_health_points)
	# Update accordingly
	set_max_health(tank_max_health)
	regen *= pow(regen_upgrade_factor, regen_points)
	bullet_cooldown *= pow(bullet_cooldown_factor, bullet_cooldown_points)


# Signal triggered when the script tries to accelerate the tank.
func _on_script_accelerate(acceleration: Vector2):
	accelerate(acceleration)


func _on_script_shoot(angle: float):
	shoot(angle)


func _on_script_error(error: String):
	emit_signal("script_error", self, error)
