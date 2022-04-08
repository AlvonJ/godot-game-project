extends CanvasLayer

onready var hp_bar = $HUD/InfoBar/H/HP
onready var hp_bar_tween = $HUD/InfoBar/H/HP/Tween

func set_tower_preview(tower_type, mouse_position):
	var drag_tower = load("res://Scene/Towers/" +  tower_type + ".tscn").instance()
	drag_tower.set_name("DragTower")
	drag_tower.modulate = Color("ad54ff3c")
	
	var range_texture = Sprite.new()
	range_texture.position = Vector2(32, 32)
	var scaling = (GameData.tower_data[tower_type]["range"] / 600.0) * 3
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
		
		
func update_health_bar(base_health):
	hp_bar_tween.interpolate_property(hp_bar, "value", hp_bar.value, base_health, 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	hp_bar_tween.start()
	if base_health >= 60:
		hp_bar.set_tint_progress("4bc800") #Green
	elif base_health <= 60 and base_health >= 25:
		hp_bar.set_tint_progress("e1be32") #Orange		
	else:
		hp_bar.set_tint_progress("e11e1e") #Red
