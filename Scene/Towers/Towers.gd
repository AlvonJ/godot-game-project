extends Node2D

const arrow_scene = preload("res://Scene/Projectiles/Arrow.tscn")

var upgrade_button = preload("res://Scene/Buttons/UpgradeButton.tscn")
		
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
		if ready and not $AnimationPlayer.is_playing():
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
	
func _on_ClickArea_input_event(viewport, event, shape_idx):
	if event.is_action_released("select") and not $AnimationPlayer.is_playing():
		var new_upgrade_button = upgrade_button.instance()
		new_upgrade_button.connect("pressed", self, "on_upgrade_pressed")
		new_upgrade_button.rect_position = global_position + Vector2(64, -64)
		if not get_parent().get_parent().get_parent().has_node("UpgradeButton"):
			get_parent().get_parent().get_parent().add_child(new_upgrade_button, false)
		
func on_upgrade_pressed():
	var build_type = "ArcherT2"
	
	var new_tower = load("res://Scene/Towers/"+ build_type + ".tscn").instance()
	var price_tower = GameData.tower_data[build_type]["price"]
	
	if get_tree().get_root().get_node("SceneHandler/GameScene").money >= price_tower :
		queue_free()
		new_tower.position = global_position
		new_tower.built = true
		new_tower.type = build_type
		new_tower.category = GameData.tower_data[build_type]["category"]
		get_tree().get_root().get_node("SceneHandler/GameScene").map_node.get_node("YSort/Towers").add_child(new_tower, true)
		new_tower.get_node("AnimationPlayer").play("deploy")
		get_tree().get_root().get_node("SceneHandler/GameScene").money -= price_tower
		get_tree().get_root().get_node("SceneHandler/GameScene/UI/HUD/InfoBar/H/Money").text = String(get_tree().get_root().get_node("SceneHandler/GameScene").money)
		
		get_parent().get_parent().get_parent().get_node("UpgradeButton").queue_free()
	
		

