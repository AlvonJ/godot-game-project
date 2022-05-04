extends "enemy.gd"

	
func _on_PlayerDetector_area_entered(area):
	if area.is_in_group("detector"):
		player_in_area = true

func _on_PlayerDetector_area_exited(area):
	if area.is_in_group("detector"):
		player_in_area = false
	
func _on_AttackDetector_area_entered(area):
	if area.is_in_group("detector"):
		in_attack_area = true
	
func _on_AttackDetector_area_exited(area):
	if area.is_in_group("detector"):
		in_attack_area = false













