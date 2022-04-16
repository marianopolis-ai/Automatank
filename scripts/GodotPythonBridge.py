from godot import exposed, export, signal
from godot import *

# https://github.com/touilleMan/godot-python/issues/199
@exposed
class TestPythonScript(Node):
	# Signal for finishing the initialisation step, has arguments related to
	# all initial stats.
	initialisation_complete = signal()
	# Signal for accelerating the tank, has a vector argument.
	accelerate_tank = signal()
	# Signal for shooting, has an angle argument.
	shoot_bullet = signal()
	# Signal for errors, an error argument.
	error = signal()
	
	# The tank's own damage group, used to check if different bodies are friendly.
	damage_group = 0
	
	# The skill points that the tank will spend.
	tank_speed_points = 0
	bullet_speed_points = 0
	tank_health_points = 0
	bullet_health_points = 0
	regen_points = 0
	bullet_cooldown_points = 0
	
	hex_colour = "#FF0000"
	
	tank_name = ""
	
	# The tank node itself.
	tank_node = None
	# The script controller of the tank.
	controller = None

	# Called when the tank initialises, with the parameter as the python script
	# that codes for this tank
	def _receive_initialise_script(self, python_script):
		# Create a namespace for the class itself.
		namespace = {}
		
		try: 
			# Run the Python script with the namespace to create the controller class.
			# The passed string from Godot is actually a GDString not an str, 
			# convert it here.
			exec(str(python_script), namespace)
			# The controller should be defined after the exec command.
			self.controller = namespace["TankController"]()
			
			# Run the controller's initialisation function and pass self as the controller.
			self.controller.receive_initialise(self)
			
			# Check the upgrades.
			self.validate_upgrades()
		except Exception as e:
			# Pass exception via signal.
			self.call("emit_signal", "error", str(e))
		
		
		# Check the integrity of upgrades here
		self.tank_node = self.get_parent()
		self.damage_group = self.tank_node.damage_group
		
		# After customisation have been completed, send the numbers as a signal.
		self.call("emit_signal", "initialisation_complete", 
			self.tank_speed_points, self.bullet_speed_points, self.tank_health_points,
			self.bullet_health_points, self.regen_points, self.bullet_cooldown_points,
			self.hex_colour, self.tank_name)
	
	
	# Checks if the upgrade points are valid.
	def validate_upgrades(self):
		if self.tank_speed_points > 5 or self.bullet_speed_points > 5 or self.tank_health_points > 5 or self.bullet_health_points > 5 or self.regen_points > 5 or self.bullet_cooldown_points > 5:
			raise Exception("You may not spend more than 5 points on any given stat.")
		if self.tank_speed_points + self.bullet_speed_points + self.tank_health_points + self.bullet_health_points + self.regen_points + self.bullet_cooldown_points > 10:
			raise Exception("You may not spend more than 10 skill points in total.")
	
	
	# Called when the tank updates.
	def _receive_update(self):
		try:
			# Send the update to the script.
			self.controller.receive_update(self, self.get_game_world())
		except Exception as e:
			self.call("emit_signal", "error", str(e))


	# Obtains a description of the game's world.
	def get_game_world(self):
		# The only node in the wall group is the tilemap. This gives us a list
		# of Vector2Ds that represent the wall blocks' position.
		wall_tiles = self.get_tree().get_nodes_in_group("wall")[0].get_used_cells()
		# A list of tank nodes on the map.
		tank_nodes = self.get_tree().get_nodes_in_group("tank")
		# A list of bullet nodes on the map.
		bullet_nodes = self.get_tree().get_nodes_in_group("bullet")
		
		# Convert the tilemap coordinate to the world coordinate.
		walls = [tile * 64.0 + Vector2(32, 32) for tile in wall_tiles]
		tanks = [self.get_body_from_node(tank) for tank in tank_nodes]
		bullets = [self.get_body_from_node(bullet) for bullet in bullet_nodes]
		
		return GameState(
			walls, 
			tanks, 
			bullets,
			self.tank_node.health,
			self.tank_node.max_health,
			self.tank_node.position,
			self.tank_node.linear_velocity,
			self.tank_node.remaining_bullet_cooldown
		)


	# Returns a Body object from its corresponding node in the game's world.
	def get_body_from_node(self, node):
		return Body(node.health, node.damage_group == self.damage_group,
					node.position, node.linear_velocity)


	# Accelerates the tank.
	def accelerate(self, vector):
		self.call("emit_signal", "accelerate_tank", vector)
	
	
	# Try to shoot a bullet at a given direction, in radians.
	def shoot(self, direction):
		self.call("emit_signal", "shoot_bullet", direction)



class GameState:
	def __init__(self, walls, tanks, bullets, health, max_health, position, velocity, cooldown):
		self.walls = walls
		self.tanks = tanks
		self.bullets = bullets
		
		self.health = health
		self.max_health = max_health
		self.position = position
		self.velocity = velocity
		self.bullet_cooldown = cooldown
	
	def __str__(self):
		return f"Tanks: {[str(tank) for tank in self.tanks]}, Bullets: {[str(bullet) for bullet in self.bullets]}, Walls: {self.walls}"


class Body:
	def __init__(self, health, friendly, position, velocity):
		self.health = health
		self.friendly = friendly
		self.position = position
		self.velocity = velocity
	
	
	def __str__(self):
		return f"Circular Body ({self.friendly}) with {self.health} health at {self.position}."


class Wall:
	def __init__(self, position):
		self.position = position
	
	
	def __str__(self):
		return f"Wall at {self.position}"
