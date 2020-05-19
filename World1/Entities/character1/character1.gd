extends KinematicBody2D


func _ready():
	pass

func dialogue_hide():
	$"Dialogue/textbox".hide()

func dialogue_show():
	$"Dialogue/textbox".show()