extends Node


func _ready():
	$MainMenu/Text/Option/Start.connect("pressed", self, "on_new_game_pressed")
	$MainMenu/Text/Option/Exit.connect("pressed", self, "on_quit_pressed")
	
func on_new_game_pressed():
	$MainMenu.queue_free()
	var game_scene = load("res://Scene/MainScenes/GameScene.tscn").instance()
	add_child(game_scene)
	 

func on_quit_pressed():
	get_tree().quit()
