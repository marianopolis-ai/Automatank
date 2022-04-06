extends "res://scripts/PlayedControlledTank.gd"


# ------ Upgrade Factors ------
# A given stat is multiplied by the factor once per each point spent on that skill.
# Currently, these numbers are picked such that spending 1 point improves the
# stat by 15% and spending 5 improves the stat by 100%, the inverse applies for
# bullet cooldown.
var tank_speed_upgrade_factor: float = 1.15
var bullet_speed_upgrade_factor: float = 1.15
var bullet_health_upgrade_factor: float = 1.15
var tank_health_upgrade_factor: float = 1.15
var regen_upgrade_factor: float = 1.15
# Bullet cooldown has <1 factor because reducing cooldown is beneficial.
var bullet_cooldown_factor: float = 0.87


# ------ Points ------
var tank_speed_points: int = 0
var bullet_speed_points: int = 0
var tank_health_points: int = 0
var bullet_health_points: int = 0
var regen_points: int = 0
var bullet_cooldown_points: int = 0


# Spend your skill points here. I'm not putting any checks because we're still
# in debug.
# Don't worry about exposing any variables, the python bridge will be greatly
# different and more restrained.
# You get to spend a total of 10 points on any combination of skills you like.
func spend_skill_points():
	# tank_speed_points = 3
	# bullet_speed_points = 5
	# ...
	# Remove the pass when you have a function body, just like Python.
	pass


func apply_upgrades():
	movement_strength *= pow(tank_speed_upgrade_factor, tank_speed_points)
	bullet_speed *= pow(bullet_speed_upgrade_factor, bullet_cooldown_points)
	bullet_health *= pow(bullet_health_upgrade_factor, bullet_health_points)
	tank_max_health *= pow(tank_health_upgrade_factor, tank_health_points)
	# Update accordingly
	set_max_health(tank_max_health)
	regen *= pow(regen_upgrade_factor, regen_points)
	bullet_cooldown *= pow(bullet_cooldown_factor, bullet_cooldown_points)


# Called when the node enters the scene tree for the first time.
func _ready():
	spend_skill_points()
	apply_upgrades()
