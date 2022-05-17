extends Node

func _ready():
	$Text/Option/Start.grab_focus()

func _on_Start_pressed():
	print("Start")


func _on_Option_pressed():
	print("Exit")
