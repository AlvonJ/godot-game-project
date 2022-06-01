extends Button

var level_path
var level


func _on_Button_pressed():
	get_node('/root/SceneHandler/HUD').queue_free()
	var game_scene = load("res://Scene/MainScenes/GameScene.tscn").instance()
	game_scene.connect("game_finished", get_node('/root/SceneHandler'), "unload_game")
	get_node('/root/SceneHandler').add_child(game_scene)
	
	if not get_node('/root/SceneHandler/GameScene').has_node(level):
		get_node('/root/SceneHandler/GameScene').add_child(load(level_path).instance())
