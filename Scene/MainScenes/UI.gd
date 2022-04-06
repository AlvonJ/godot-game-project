extends CanvasLayer


func set_tower_preview(tower_type, mouse_position):
	var drag_tower = load("res://Scene/Towers/" +  tower_type + ".tscn").instance()
	drag_tower.set_name("DragTower")
	drag_tower.modulate = Color("ad54ff3c")
	
	var range_texture = Sprite.new()
	range_texture.position = Vector2(32, 32)
	var scaling = GameData.tower_data[tower_type]["range"] / 600.0
	range_texture.scale = Vector2(scaling, scaling)
	var texture = load("res://UI/range_overlay.png")
	range_texture.texture = texture
	range_texture.modulate = Color("ad54ff3c")
	
	
	var control = Control.new()
	control.add_child(drag_tower, true) 
	control.add_child(range_texture, true)
	control.rect_position = mouse_position
	control.set_name("TowerPreview")
	add_child(control, true)
	move_child($TowerPreview, 0)

func update_tower_preview(new_position, color):
	$TowerPreview.rect_position = new_position
	if $TowerPreview/DragTower.modulate != Color(color):
		$TowerPreview/DragTower.modulate = Color(color)
		$TowerPreview/Sprite.modulate = Color(color)

##
## Game Control functions
##
func _on_PausePlay_pressed():
	if get_parent().build_mode:
		get_parent().cancel_build_mode()
	if get_tree().is_paused():
		get_tree().paused = false
	elif get_parent().current_wave == 0:
		get_parent().current_wave += 1
		get_parent().start_next_wave()
	else:
		get_tree().paused = true


func _on_SpeedUp_pressed():
	if get_parent().build_mode:
		get_parent().cancel_build_mode()
	if Engine.get_time_scale() == 2.0:
		Engine.set_time_scale(1.0)
	else:
		Engine.set_time_scale(2.0)		
