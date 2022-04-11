extends KinematicBody2D

export var speed: int = 100
var velocity: Vector2 = Vector2.ZERO
var path: Array = []
var velocity1: Vector2 = Vector2.ZERO
var path1: Array = []
var navigation: Navigation2D = null
var navigation1: Navigation2D = null
var bonfire = null
var player = null
var in_attack_area: bool = false
var player_in_area: bool = false

##############
#TAKE DAMAGE
##############
signal base_damage(damage)
signal dead(money)

var hp = 50
var base_damage = 0.1

onready var health_bar = $HealthBar
onready var animation_player = $AnimationPlayer

func _ready():
	# check if the object have a group
	var tree = get_tree()
	if tree.has_group("Navigation"):
		navigation = tree.get_nodes_in_group("Navigation")[0]
		navigation1 = tree.get_nodes_in_group("Navigation")[0]
	if tree.has_group("Bonfire"):
		bonfire = tree.get_nodes_in_group("Bonfire")[0]
	if tree.has_group("Player"):
		player = tree.get_nodes_in_group("Player")[0]
	
#	# HealthBar progression
	health_bar.max_value = hp
	health_bar.value = hp
	health_bar.set_as_toplevel(true)
	
	# start the walk animation
	animation_player.play("walk")
		
func _physics_process(delta):
	if bonfire and navigation:			
		generate_bonfire_path()
		navigate_the_bonfire()
		if player_in_area:
			generate_player_path()
			navigate_the_player()
			if in_attack_area:
				animation_player.play("attack")
				hit(base_damage)
			else:
				animation_player.play("walk")
			move_to_player()
		move_to_bonfire()
	
#	# Set HealthBar Position
	health_bar.set_position(position - Vector2(13,17))

## Move to bonfire
func navigate_the_bonfire():
	if path.size() > 0:
		velocity = global_position.direction_to(path[1]) * speed
		
		if global_position == path[0]:
			path.pop_front()
			
func generate_bonfire_path():
	if navigation != null and bonfire != null:
		path = navigation.get_simple_path(global_position, bonfire.global_position, true)

func move_to_bonfire():
	velocity = move_and_slide(velocity)

## Move to player
func navigate_the_player():
	if path1.size() > 0:
		velocity1 = global_position.direction_to(path1[1]) * speed
		
		if global_position == path1[0]:
			path1.pop_front()
			
func generate_player_path():
	if navigation1 != null and player != null:
		path1 = navigation1.get_simple_path(global_position, player.global_position, true)

func move_to_player():
	velocity1 = move_and_slide(velocity1)
	

#onready var impact_area = $Impact
#var projectile_impact = preload("res://Scenes/SupportScenes/ProjectileImpact.tscn")

func hit(damage):
	emit_signal("base_damage", damage)

	

func on_hit(damage):
#	impact()
	hp -= damage
	health_bar.value = hp
	if hp <= 0:
		on_destroy()
		
func on_destroy():
	animation_player.queue_free()
	emit_signal("dead", 30)
	self.queue_free()
	












