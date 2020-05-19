extends StaticBody2D


func _ready():
	pass
	
func initiateDialogue():
	if !get_node("../..").gravediggerDefeated:
		dialogue_show()
		$Dialogue.display_text()
	else:
		get_tree().get_root().get_node("Node/YSort/Player").position = Vector2(-2465.57666,7953.019531)

func dialogue_hide():
	$"Dialogue/textbox".hide()

func dialogue_show():
	$"Dialogue/textbox".show()