extends Node2D

signal game_finished(result)

var map_node

var build_mode = false
var build_valid = false
var build_tile
var build_location
var build_type

var current_wave = 0
var enemies_in_wave = 0

var base_health = 100
var money = 500

var enemies = [
		[
			["ShadowHound", 2], ["ShadowHound", 2], ["SlimeBlack", 0.7]
		],
		[
			["SlimeBlack", 3], ["ShadowHound", 2], ["SlimeBlack", 0.5], ["SlimeBlack", 2]
		],
		[
			["SlimeBlack", 0.5], ["ShadowHound", 1], ["ShadowHound", 1], ["SlimeBlack", 2], ["ShadowHound", 1],["ShadowHound", 1],
		],
				[
			["SlimeBlack", 2], ["ShadowHound", 3], ["ShadowHound", 1], ["SlimeBlack", 2], ["ShadowHound", 1], ["ShadowHound", 1], ["SlimeBlack", 2],
		],
				[
			["SlimeBlack", 2], ["ShadowHound", 3], ["ShadowHound", 1], ["SlimeBlack", 2], ["ShadowHound", 1], ["ShadowHound", 1], ["ShadowHound", 1], ["SlimeBlack", 2],
		],
				[
			["SlimeBlack", 2], ["ShadowHound", 3], ["ShadowHound", 1], ["SlimeBlack", 2], ["ShadowHound", 1], ["ShadowHound", 1], ["SlimeBlack", 2], ["ShadowHound", 1], ["ShadowHound", 1], ["SlimeBlack", 2], ["ShadowHound", 1]
		],
	]

func _ready():
	add_child(map_node)

	$UI/HUD/InfoBar/Money.text = String(money)
	
	for i in get_tree().get_nodes_in_group("build_buttons"):
		i.connect("pressed", self, "initiate_build_mode", [i.get_name()])
		
	
func _process(delta):
	if build_mode:
		update_tower_preview()
	if enemies_in_wave == 0 and current_wave > 0 and current_wave <= (enemies.size() - 1):
		start_next_wave()

func _unhandled_input(event):
	if event.is_action_released("cancel") and build_mode == true:
		cancel_build_mode()
	if event.is_action_released("select"):
		if build_mode == true:
			verify_and_build()
			cancel_build_mode()
		if map_node.has_node("UpgradeButton"):
			map_node.get_node("UpgradeButton").queue_free()


##
## Wave Functions
##
	
func start_next_wave():
	var wave_data = retrieve_wave_data()
	yield(get_tree().create_timer(2), "timeout")
	$UI/HUD/InfoBar/Wave.text = "Wave " + String(current_wave)
	spawn_enemies(wave_data)

func retrieve_wave_data():
	var wave_data = enemies[current_wave]
	current_wave += 1
	enemies_in_wave = wave_data.size()
	return wave_data

func spawn_enemies(wave_data):
	for i in wave_data:
		var new_enemy = load("res://Scene/Enemies/"+ i[0] +".tscn").instance()
		new_enemy.connect("base_damage", self, "on_base_damage")
		new_enemy.connect("dead", self, "on_dead")
		new_enemy.type = i[0]
		var random_x = randi() % 1430 - 80
		var random_y
		if random_x <= -20 or random_x > 1300:
			random_y = randi() % 850 - 50
		else:
			var list_random_y = [-49, 780]
			random_y = list_random_y[randi() % 2]
		
		new_enemy.global_position = Vector2(random_x, random_y)
		map_node.get_node("YSort").get_node("Enemies").add_child(new_enemy, true)
		yield(get_tree().create_timer(i[1]), "timeout")
		
		
##
## Building Functions
##
	
func initiate_build_mode(tower_type):
	if build_mode:
		cancel_build_mode()
	build_type = tower_type + "T1"
	build_mode = true
	$UI.set_tower_preview(build_type, get_global_mouse_position())

func update_tower_preview():
	var mouse_position = get_global_mouse_position()
	var current_tile = map_node.get_node("TowerExclusion").world_to_map(mouse_position)
	var tile_position = map_node.get_node("TowerExclusion").map_to_world(current_tile)
	
	if map_node.get_node("TowerExclusion").get_cellv(current_tile) == -1:
		$UI.update_tower_preview(tile_position, "ad54ff3c")
		build_valid = true
		build_location = tile_position
		build_tile = current_tile
	else:
		$UI.update_tower_preview(tile_position, "adff4545")
		build_valid = false
	
func cancel_build_mode():
	build_mode = false
	build_valid = false
	$UI/TowerPreview.free()
	
func verify_and_build():
	if build_valid:
		var new_tower = load("res://Scene/Towers/"+ build_type + ".tscn").instance()
		var price_tower = GameData.tower_data[build_type]["price"]
		
		if money >= price_tower :
			new_tower.position = build_location
			new_tower.built = true
			new_tower.type = build_type
			new_tower.category = GameData.tower_data[build_type]["category"]
			map_node.get_node("YSort/Towers").add_child(new_tower, true)
			new_tower.get_node("AnimationPlayer").play("deploy")
			map_node.get_node("TowerExclusion").set_cellv(build_tile, 4)
			money -= price_tower
			$UI/HUD/InfoBar/Money.text = String(money)

func on_base_damage(damage):
	base_health -= damage
	if base_health <= 0:
		emit_signal("game_finished", false)
	else:
		$UI.update_health_bar(base_health)
		
func on_dead(dead_money):
	money += dead_money
	$UI/HUD/InfoBar/Money.text = String(money)
	
	enemies_in_wave -= 1
