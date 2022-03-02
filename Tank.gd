# This makes the code execute in the editor, so we can see the custom circle
# drawing without launching the game itself.
tool
extends KinematicBody2D

# Set a cap on the velocity of the object.
const MAXIMUM_VELOCITY: float = 30.0
# Strength of the kinetic friction acting on the object.
const FRICTION_STRENGTH: float = MAXIMUM_VELOCITY * 0.05
# Strength of the movement of the player.
# TODO: allow upgrades for movement strength.
const MOVEMENT_STRENGTH: float = MAXIMUM_VELOCITY * 0.1

# Velocity of the object
var velocity: Vector2 = Vector2.ZERO
# The acceleration (motion) that the player/script intends.
var intended_acceleration: Vector2 = Vector2.ZERO


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
	# Add the player's intended acceleration to the velocity.
	# Multiplying by delta to make sure that it's scaled by time.
	velocity += intended_acceleration * delta
	apply_friction(delta)
	
	# Make sure that the velocity stays within the maximum velocity.
	if velocity.length() > MAXIMUM_VELOCITY:
		velocity = velocity.normalized() * MAXIMUM_VELOCITY
	
	# Update velocity after collision
	velocity = move_and_slide(velocity)


# Applies kinetic friction on the object.
func apply_friction(delta: float):
	# Friction on the reverse direction of the current motion.
	# Make sure that the friction length does not exceed the current velocity.
	var friction = -velocity.normalized() * min(FRICTION_STRENGTH, velocity.length())
	# Multiply by the amount of time passed.
	velocity += friction * delta


# Accelerate function, intended to be exposed for SCRIPT control.
func accelerate(acceleration: Vector2):
	# Normalise the acceleration to prevent cheating by speeding.
	intended_acceleration = acceleration.normalized() * MOVEMENT_STRENGTH


# Override the default render function to manually draw circles for the tank, 
# as textures and sprites are not needed.
func _draw():
	draw_circle(position, 32, Color.dodgerblue)
	draw_circle(position, 30, Color.darkslateblue)
