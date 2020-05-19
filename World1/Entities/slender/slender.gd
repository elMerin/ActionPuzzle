extends StaticBody2D


func _ready():
	pass
	
func initiateDialogue():
	dialogue_show()
	$Dialogue.display_text()

func dialogue_hide():
	$"Dialogue/textbox".hide()

func dialogue_show():
	$"Dialogue/textbox".show()
