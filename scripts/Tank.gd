extends "res://scripts/CircularBody.gd"


# Strength of the movement of the tank.
# TODO: allow upgrades for movement strength.
var movement_strength: float = 1000.0
# Initial speed of the bullets that the tank shoots.
# TODO: allow upgrades for bullet speed.
var bullet_speed: float = 500.0
# Initial health of the bullet that the tank shoots.
# TODO: allow upgrades for bullet health.
var bullet_health: float = 40.0
# Initial health of the tank.
# TODO: allow upgrades for max health.
var tank_max_health: float = 100.0

# The acceleration (motion) that the player/script intends.
var intended_acceleration: Vector2 = Vector2.ZERO
# Normalised actual acceleration of the tank.
var actual_acceleration: Vector2 = Vector2.ZERO


# Size parameters of the cannon. These are purely cosmetic, the cannon does not
# participate in collision.
var cannon_half_width = 24.0
var cannon_length = 128.0

# Colour parameters of the cannon.
var cannon_fill_colour = Color("#9e9e9e")
var cannon_stroke_colour = Color("#616161")

# Orientation of the cannon, in radians.
var cannon_orientation = 0.0

var bullet_scene = preload("res://Bullet.tscn")

func _ready():
	# Define the damage group by the tank's id to ensure uniqueness.
	# This will be passed to the bullets that it creates.
	damage_group = get_instance_id()
	
	# Update the max health.
	set_max_health(tank_max_health)


# On update.
func _process(delta: float):	
	# Call the update method on process so the _draw() method gets called every
	# frame.
	update()


# On physics update.
# No acceleration is given here, as acceleration is going to be controlled
# by either the player or a script.
func _physics_process(delta: float):
	# Add the player's acceleration to the velocity.
	# Multiplying by delta to make sure that it's scaled by time.
	apply_central_impulse(actual_acceleration * delta)
	
	
	# Reset the acceleration after it has been applied.
	clear_acceleration()


# Accelerate function, intended to be exposed for SCRIPT control.
func accelerate(acceleration: Vector2):
	intended_acceleration += acceleration
	
	# Update the actual acceleration as the normalised acceleration multiplied 
	# by the movement strength.
	actual_acceleration = intended_acceleration.normalized() * movement_strength


# Clears the intended and actual acceleration.
func clear_acceleration():
	intended_acceleration = Vector2.ZERO
	actual_acceleration = Vector2.ZERO
	

func _draw():
	# Fill the cannon.
	draw_colored_polygon(
		PoolVector2Array([
			# Bottom left point
			Vector2(0, -cannon_half_width).rotated(cannon_orientation),
			# Top left point
			Vector2(0, cannon_half_width).rotated(cannon_orientation),
			# Top right point
			Vector2(cannon_length, cannon_half_width).rotated(cannon_orientation),
			# Bottom right point
			Vector2(cannon_length, -cannon_half_width).rotated(cannon_orientation)
		]),
		Color.transparent.linear_interpolate(cannon_fill_colour, transparency)
	)
	# Stroke the cannon.
	draw_polyline(
		PoolVector2Array([
			# Bottom left point
			Vector2(0, -cannon_half_width).rotated(cannon_orientation),
			# Top left point
			Vector2(0, cannon_half_width).rotated(cannon_orientation),
			# Top right point
			Vector2(cannon_length, cannon_half_width).rotated(cannon_orientation),
			# Bottom right point
			Vector2(cannon_length, -cannon_half_width).rotated(cannon_orientation),
			# Bottom left point again to close out the path.
			Vector2(0, -cannon_half_width).rotated(cannon_orientation)
		]),
		Color.transparent.linear_interpolate(cannon_stroke_colour, transparency),
		# 4 width strokes.
		4.0
	)
	# Call the parent draw function here to have the cannon behind the tank.
	._draw()
	
	# Draw the HP bar background
	draw_rect(Rect2(
		# Top left corner
		Vector2(-radius, radius + 10),
		# Width and height
		Vector2(radius * 2, 10)
	), Color.gray)
	# Draw the HP bar
	draw_rect(Rect2(
		# Top left corner
		Vector2(-radius + 1, radius + 11),
		# Width multiplied by health ratio.
		Vector2((radius * 2 - 2) * (health / max_health), 8)
		# Interpolate healthiness with health ratio.
	), Color.red.linear_interpolate(Color.green, health / max_health).darkened(0.2))


# Spawns a bullet that belongs to the tank. Direction in radians.
func shoot(direction):
	# Make a new bullet
	var bullet = bullet_scene.instance()
	
	# Put it ahead of the tank
	bullet.set_position(position + Vector2.RIGHT.rotated(direction) * radius * 1.5)
	# Give it an initial velocity
	bullet.linear_velocity = Vector2.RIGHT.rotated(direction) * bullet_speed
	
	# Give it this tank's damage group.
	bullet.damage_group = damage_group
	# Copy the tank's colour
	bullet.inner_circle_colour = inner_circle_colour
	
	# Give it its health
	bullet.set_max_health(bullet_health)
	
	# Spawn the bullet
	get_tree().get_root().add_child(bullet)
