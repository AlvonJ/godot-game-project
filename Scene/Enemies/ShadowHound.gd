extends PathFollow2D


var speed = 200

func _physics_process(delta):
	offset += speed * delta
