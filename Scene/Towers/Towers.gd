extends Node2D

const arrow_scene = preload("res://Scene/Projectiles/Arrow.tscn")

var type
var category
var enemy_array = []
var built = false
var enemy
var ready = true
var bonfire_position = Vector2(640, 360)

func _ready():
	if built:
		self.get_node("Range/CollisionShape2D").get_shape().radius = 0.5 * GameData.tower_data[type]["range"]

func _physics_process(delta):
	if enemy_array.size() != 0 and built:
		select_enemy()
#		if not $AnimationPlayer.is_playing():
#			turn(new_arrow)
		if ready:
			fire()
	else:
		enemy = null
	
#func turn(node):
#	node.look_at(enemy.position)

func select_enemy():
	var enemy_progress_array = []
#	for i in enemy_array:
#		enemy_progress_array.append(bonfire_position - i.position)
#	var min_offset = enemy_progress_array.min()
#	var enemy_index = enemy_progress_array.find(min_offset)
	for i in enemy_array:
		enemy_progress_array.append(i)
	enemy = enemy_array[0]

func fire():
	ready = false
	if category == "Projectile":
		fire_arrow()

	yield(get_tree().create_timer(GameData.tower_data[type]["rof"]), "timeout")
	ready = true

func fire_arrow():
	var new_arrow = arrow_scene.instance()
	new_arrow.global_position = global_position + Vector2(32, -5)
	new_arrow.enemy = enemy
	new_arrow.type = type
	
	get_parent().get_parent().get_node("Projectiles").add_child(new_arrow, true)


func _on_Range_body_entered(body):
	enemy_array.append(body)

func _on_Range_body_exited(body):
	enemy_array.erase(body)