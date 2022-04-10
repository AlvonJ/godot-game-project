extends "enemy.gd"

	
func _on_PlayerDetector_area_entered(area):
	player_in_area = true

func _on_PlayerDetector_area_exited(area):
	player_in_area = false
	
func _on_AttackDetector_area_entered(area):
	in_attack_area = true
	
func _on_AttackDetector_area_exited(area):
	in_attack_area = false














