# The circular body script describes *any* circular body in the game. Including
# tanks and projectiles.
# The important property of the circular body is that it:
# - Has a velocity and moves following the velocity.
# - Is affected by friction, whose strength defined by a customisable variable.
# - Has health.
# - Upon collision, lose a certain amount of health and accelerates away from
#   the other body.

# The tool keyword makes the code execute in the editor, so we can see the 
# custom circle drawing without launching the game itself.
tool
extends RigidBody2D


# Defines the health of the object. Can be overridden by inheritors.
var health = 100.0

# The colour of the body. Can be overridden by inheritors.
var inner_circle_colour = "#2196f3"

# The size of the body. Can be overridden by inheritors.
var radius = 64.0


func _ready():
	pass # Replace with function body.


# Initialises the object. Call after the inheritor is ready.
func initialise():
	# Update the radius after the inheritor updates it.
	$CollisionShape2D.shape.set_radius(radius)


# On update.
func _process(delta: float):
	# Call the update method on process so the _draw() method gets called every
	# frame.
	update()
	
	# When the body does not have enough health, destroy it.
	if health <= 0:
		queue_free()


# Override the default render function to manually draw circles for the tank, 
# as textures and sprites are not needed.
func _draw():
	# Apparently the draw positions are relative to the current object. So we 
	# have to supply 0 to be the parameter.
	
	# Draw the outer circle.
	draw_circle(Vector2.ZERO, radius, Color("#616161"))
	
	# Draw the inner circle.
	draw_circle(Vector2.ZERO, radius - 4, Color("#2196f3"))
