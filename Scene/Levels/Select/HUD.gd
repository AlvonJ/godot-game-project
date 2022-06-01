extends Control

export (PackedScene) var base_button
export (int) var total_levels = 0
export (NodePath) var grid

func _ready():
	grid = get_node(grid)
	
	if !total_levels <= 10:
		column_size()
		
	for i in range(0,total_levels):
		generate_button(i + 1)


func generate_button(name:int):
	var bb = base_button.instance()
	bb.set_name(str(name))
	bb.set_text(str(name))
	bb.level_path = ("res://Scene/Levels/Level" + str(name) + ".tscn")
	grid.add_child(bb)
	

func column_size():
	if total_levels % 2 == 0:
		grid.columns = total_levels/5
	else:
		grid.columns = total_levels/5 + 1
