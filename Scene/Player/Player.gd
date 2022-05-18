extends KinematicBody2D


var motion = Vector2(0, 0)

const SPEED = 300

var attack = false

func _ready():
	for i in get_tree().get_nodes_in_group("attack_button"):
		i.connect("button_down", self, "initiate_attack")
		i.connect("button_up", self, "stop_attack")
		
func _physics_process(delta):
	move_horizontal()
	move_vertical()
	if attack:
		$AnimationPlayer.play("attack")
	else:
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
		$AnimationPlayer.play("idle")
	else:
		$AnimationPlayer.play("walk")
		if motion.x > 0:
			$Sprite.scale = Vector2(1,1)
		elif motion.x < 0:
			$Sprite.scale = Vector2(-1,1)
			
func initiate_attack():
	attack = true
	
func stop_attack():
	attack = false
			
func _on_HitBox_body_entered(body):
	if body.is_in_group("Enemy"):
		body.on_hit(GameData.human_builder["damage"])
		
