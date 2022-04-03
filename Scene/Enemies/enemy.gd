extends KinematicBody2D

export var speed: int = 200
var velocity: Vector2 = Vector2.ZERO
var path: Array = []
var navigation: Navigation2D = null
var bonfire = null
# Testing purpose
#var player = null

func _ready():
	var tree = get_tree()
	if tree.has_group("Navigation"):
		navigation = tree.get_nodes_in_group("Navigation")[0]
	if tree.has_group("Bonfire"):
		bonfire = tree.get_nodes_in_group("Bonfire")[0]
#	if tree.has_group("Player"):
#		player = tree.get_nodes_in_group("Player")[0]
		
func _physics_process(delta):
	if bonfire and navigation:
		generate_path()
		navigate()
	move()
	
func navigate():
	if path.size() > 0:
		velocity = global_position.direction_to(path[1]) * speed
		
		if global_position == path[0]:
			path.pop_front()
func generate_path():
	if navigation != null and bonfire != null:
		path = navigation.get_simple_path(global_position, bonfire.global_position, true)

		
func move():
	velocity = move_and_slide(velocity)


