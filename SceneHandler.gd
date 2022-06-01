extends Node

func _ready():
	load_main_menu()
	
func load_main_menu():
	$MainMenu/Text/Option/Start.connect("pressed", self, "on_new_game_pressed")
	$MainMenu/Text/Option/Exit.connect("pressed", self, "on_quit_pressed")
	$MainMenu/Text/Option/Levels.connect("pressed", self, "on_levels_pressed")
	$Music2.stop()
	$Music.play()
	
func unload_main_menu():
	$MainMenu/Text/Option/Start.disconnect("pressed", self, "on_new_game_pressed")
	$MainMenu/Text/Option/Exit.disconnect("pressed", self, "on_quit_pressed")
	$MainMenu/Text/Option/Levels.disconnect("pressed", self, "on_levels_pressed")
	
func on_new_game_pressed():
	unload_main_menu()
	$MainMenu.queue_free()
	$Music.stop()
	$Music2.play()
	var game_scene = load("res://Scene/MainScenes/GameScene.tscn").instance()
	game_scene.connect("game_finished", self, "unload_game")
	add_child(game_scene)
	
func on_levels_pressed():
	unload_main_menu()
	$MainMenu.queue_free()
	var levels_scene = load("res://Scene/Levels/Select/Selection.tscn").instance()
	add_child(levels_scene)
	 
func on_quit_pressed():
	get_tree().quit()

func unload_game(result):
	if not has_node("MainMenu"):
		$GameScene.queue_free()
		var main_menu = load("res://Scene/MainMenu/MainMenu.tscn").instance()
		add_child(main_menu)
		load_main_menu()	
