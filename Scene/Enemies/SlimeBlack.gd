extends PathFollow2D


var speed = 100

func _physics_process(delta):
	offset += speed * delta
