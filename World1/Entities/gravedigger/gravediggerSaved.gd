extends StaticBody2D

func _ready():
	$Sprite.modulate = Color(1, 1, 1, 0)
	$CollisionShape2D.disabled = true
	pass
	
func initiateDialogue():
	dialogue_show()
	$Dialogue.display_text()

func dialogue_hide():
	$"Dialogue/textbox".hide()

func dialogue_show():
	$"Dialogue/textbox".show()


func hide():
	$Tween.interpolate_property($Sprite, "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), 2.0, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()
	$CollisionShape2D.disabled = true

func show():
	$Sprite.modulate = Color(1, 1, 1, 1)
	$CollisionShape2D.set_deferred("disabled",false)
