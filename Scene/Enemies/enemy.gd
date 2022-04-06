extends KinematicBody2D

export var speed: int = 200
var velocity: Vector2 = Vector2.ZERO
var path: Array = []
var navigation: Navigation2D = null
var bonfire = null
# Testing purpose
#var player = null

##############
#TAKE DAMAGE
##############
signal base_damage(damage)

var hp = 50
var base_damage = 21

onready var health_bar = $HealthBar

func _ready():
	var tree = get_tree()
	if tree.has_group("Navigation"):
		navigation = tree.get_nodes_in_group("Navigation")[0]
	if tree.has_group("Bonfire"):
		bonfire = tree.get_nodes_in_group("Bonfire")[0]
#	if tree.has_group("Player"):
#		player = tree.get_nodes_in_group("Player")[0]
	
#	# HealthBar progression
	health_bar.max_value = hp
	health_bar.value = hp
	health_bar.set_as_toplevel(true)
		
func _physics_process(delta):
	if bonfire and navigation:
		generate_path()
		navigate()
	move()
	
#	# Set HealthBar Position
	health_bar.set_position(position - Vector2(15,17))
	
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



#onready var impact_area = $Impact
#var projectile_impact = preload("res://Scenes/SupportScenes/ProjectileImpact.tscn")


func on_hit(damage):
#	impact()
	hp -= damage
	health_bar.value = hp
	if hp <= 0:
		on_destroy()
		
func on_destroy():
	$AnimatedSprite.queue_free()
	yield(get_tree().create_timer(0.2), "timeout")
	self.queue_free()
