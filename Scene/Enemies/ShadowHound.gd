extends "enemy.gd"

	
func _on_PlayerDetector_area_entered(area):
	player_in_area = true
	return player_in_area

func _on_PlayerDetector_area_exited(area):
	player_in_area = false
	return player_in_area
	
func _on_AttackDetector_area_entered(area):
	in_attack_area = true
	return in_attack_area
	
func _on_AttackDetector_area_exited(area):
	in_attack_area = false
	return in_attack_area

	












