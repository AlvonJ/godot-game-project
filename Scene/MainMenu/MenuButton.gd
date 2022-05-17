tool
extends TextureButton

export(String) var text = "Start"
export(int) var arrow_margin_from_center = 100

func _ready():
	setup_text()
	hide_arrows()
	set_focus_mode(true)

func _process(delta):
	if Engine.editor_hint:
		setup_text()
		show_arrows()

func setup_text():
	$RichTextLabel.bbcode_text = "[center]%s[/center]" % [text]
	
func show_arrows():
	for arrow in[$LeftDog, $RightDog]:
		arrow.visible = true
		arrow.global_position.y = rect_global_position.y + (rect_size.y / 3.0)

	var center_x = rect_global_position.x + (rect_size.x / 2)
	$LeftDog.global_position.x = center_x - arrow_margin_from_center
	$RightDog.global_position.x = center_x + arrow_margin_from_center

func hide_arrows():
	for arrow in [$LeftDog,$RightDog]:
		arrow.visible = false


func _on_TextureButton_focus_entered():
	show_arrows()

func _on_TextureButton_focus_exited():
	hide_arrows()


func _on_TextureButton_mouse_entered():
	grab_focus()
