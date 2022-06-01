extends Area2D

onready var big_circle = $BigCircle
onready var small_circle = $BigCircle/SmallCircle

onready var max_distance = $CollisionShape2D.shape.radius

var touched = false

var velocity = Vector2(0, 0)

func _input(event):
	if event is InputEventScreenTouch:
		var distance = event.position.distance_to(big_circle.global_position)
		if not touched:
			if distance < max_distance:
				touched = true
		else:
			touched = false
			small_circle.position = Vector2(0, 0)
				
func _process(delta):
	if touched:
		 small_circle.global_position = get_global_mouse_position()
		 small_circle.position = big_circle.position + (small_circle.position - big_circle.position).clamped(max_distance)

func player_velocity():
	velocity.x = small_circle.position.x / max_distance
	velocity.y = small_circle.position.y / max_distance
	return velocity.normalized()
	
