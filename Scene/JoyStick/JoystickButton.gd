extends TouchScreenButton

var radius = Vector2(32, 32)
var boundary = 64

var ongoing_drag = -1

var return_accel = 20

var threshold = 10

signal _on_joystick_touched(value)

#func _process(delta):
#	print(get_button_pos().normalized())

func get_button_pos():
	return position + radius

func _input(event):
	if event is InputEventScreenDrag or (event is InputEventScreenTouch and event.is_pressed()):
		var event_dist_from_centre = (event.position - get_parent().global_position).length()
		
		if event_dist_from_centre <= boundary * global_scale.x or event.get_index() == ongoing_drag:
			set_global_position(event.position - radius * global_scale)
		
			if get_button_pos().length() > boundary:
				set_position(get_button_pos().normalized() * boundary - radius) 
			
			ongoing_drag = event.get_index()
			emit_signal("_on_joystick_touched", get_value())
			
		
	if event is InputEventScreenTouch and !event.is_pressed() and event.get_index() == ongoing_drag:
		ongoing_drag = -1
		position = Vector2(0, 0) - radius
		
func get_value():
	if get_button_pos().length() > threshold:
		return get_button_pos().normalized()
	return Vector2(0, 0)


		
		
