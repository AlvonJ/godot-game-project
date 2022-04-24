extends KinematicBody2D

var enemy = null
var move = Vector2.ZERO
var speed = 10
var type

func _physics_process(delta):
	move = Vector2.ZERO
	
	if is_instance_valid(enemy):
		look_at(enemy.position)
		move = position.direction_to(enemy.position) * speed
	else:
		queue_free()
	
	move_and_collide(move)
	
func _on_Detection_body_entered(body):
	if body == enemy:
		enemy.on_hit(GameData.tower_data[type]["damage"])
		queue_free()
