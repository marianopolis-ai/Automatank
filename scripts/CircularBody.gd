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

# Global constant: the damage that a body takes per second per body that it's 
# overlapping with.
var collision_damage = 150
# Bodies with health ratios less than this value will appear more and more
# transparent as it loses health.
var transparency_threshold = 0.5

# Defines the health of the object. Can be overridden by inheritors.
var health = 100.0
var max_health = 100.0

# The colour of the body. Can be overridden by inheritors.
var inner_circle_colour = "#2196f3"
# The alpha value of the body.
var transparency = 1

# The size of the body. Can be overridden by inheritors.
var radius = 64.0

# The number of circular bodies that this is overlapping with.
var overlap_count = 0


# Object belongs to a damage group. Objects in the same damage group do not 
# damage each other.
var damage_group = 0


func _ready():
	pass # Replace with function body.


func set_max_health(new_max_health):
	max_health = new_max_health
	health = new_max_health


func set_radius(new_radius):
	radius = new_radius
	$CollisionShape2D.shape.set_radius(radius)
	$RepulsionArea/CollisionShape2D.shape.set_radius(radius)


# On update.
func _process(delta: float):
	# Call the update method on process so the _draw() method gets called every
	# frame.
	update()
	
	# Take the damage.
	health -= overlap_count * collision_damage * delta
	
	# If the body's health is less than the threshold, it will become more and 
	# more transparent.
	var health_ratio = health / max_health
	if health_ratio < transparency_threshold:
		transparency = health_ratio / transparency_threshold
	else:
		transparency = 1
	
	# When the body does not have enough health, destroy it.
	if health <= 0:
		queue_free()


# Override the default render function to manually draw circles for the tank, 
# as textures and sprites are not needed.
func _draw():
	# Apparently the draw positions are relative to the current object. So we 
	# have to supply 0 to be the parameter.
	
	# Draw the outer circle.
	draw_circle(Vector2.ZERO, radius, 
		# Apply transparency by interpolating from transparent.
		Color.transparent.linear_interpolate(Color("#616161"), transparency))
	
	# Draw the inner circle.
	draw_circle(Vector2.ZERO, radius - 4, 
		# Apply transparency by interpolating from transparent.
		Color.transparent.linear_interpolate(inner_circle_colour, transparency))


# Called when another rigid body enters the area.
func _on_another_body_entered(body):
	# if this is an unfriendly object
	if "damage_group" in body and body.damage_group != damage_group:
		overlap_count += 1

# Called when another rigid body leaves the area.
func _on_another_body_exited(body):
	# if this is an unfriendly object
	if "damage_group" in body and body.damage_group != damage_group:
		overlap_count -= 1
