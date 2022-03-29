extends KinematicBody2D


var motion = Vector2(0, 0)

const SPEED = 300

func _physics_process(delta):
	move_horizontal()
	move_vertical()
	animate()
	move_and_slide(motion)


func move_horizontal():
	if Input.is_action_pressed("left") and not Input.is_action_pressed("right"):
		motion.x = -SPEED
	elif Input.is_action_pressed("right") and not Input.is_action_pressed("left"):
		motion.x = SPEED
	else:
		motion.x = 0
		
func move_vertical():
	if Input.is_action_pressed("up"):
		motion.y = -SPEED
	elif Input.is_action_pressed("down"):
		motion.y = SPEED
	else:
		motion.y = 0
	
func animate():
	if motion.x == 0 and motion.y == 0:
		$PlayerAnimation.play("idle")
	else:
		$PlayerAnimation.play("walk")
		if motion.x > 0:
			$PlayerAnimation.flip_h = false
		elif motion.x < 0:
			$PlayerAnimation.flip_h = true
		
	
