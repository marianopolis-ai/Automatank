extends "res://scripts/CircularBody.gd"


# Strength of the movement of the tank.
# TODO: allow upgrades for movement strength.
const MOVEMENT_STRENGTH: float = 1000.0

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

func _ready():
	pass # Replace with function body.


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
	actual_acceleration = intended_acceleration.normalized() * MOVEMENT_STRENGTH


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
		cannon_fill_colour
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
		cannon_stroke_colour,
		# 4 width strokes.
		4.0
	)
	# Call the parent draw function here to have the cannon behind the tank.
	._draw()
