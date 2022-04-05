extends "res://scripts/CircularBody.gd"

# Global constant: bullet size
var bullet_radius: float = 24.0

# Called when the node enters the scene tree for the first time.
func _ready():
	# Bullets do not need to be seen like tanks, so they can start becoming
	# transparent as early as having taken a bit of damage.
	transparency_threshold = 0.8
	
	# Update the radius.
	set_radius(bullet_radius)


# When another body enters.
func _on_bullet_body_entered(body):
	# Make the bullet lose health rapidly when it encounters a wall 
	# (which has no damage group). There is no hook to reduce the overlap count
	# because once a bullet is in contact with a wall it is expected to be
	# destroyed shortly.
	if not "damage_group" in body:
		overlap_count += 1
