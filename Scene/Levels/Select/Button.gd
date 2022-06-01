extends Button

var level_path
var level


func _on_Button_pressed():
	get_node('/root/SceneHandler/HUD').queue_free()
	var game_scene = load("res://Scene/MainScenes/GameScene.tscn").instance()
	game_scene.connect("game_finished", get_node('/root/SceneHandler'), "unload_game")
	game_scene.map_node = load(level_path).instance()
	get_node('/root/SceneHandler').add_child(game_scene)
	
