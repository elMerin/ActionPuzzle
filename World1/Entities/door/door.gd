extends StaticBody2D

func _ready():
	$Sprite.modulate = Color(1, 1, 1, 0)
	$CollisionShape2D.disabled = true
	pass

func initiateDialogue():
	get_node("../Player").position = Vector2(-326.134491,7101.355957)
	get_node("../..").gravediggerDefeated = true
	
func fadeIn():
	$Tween.interpolate_property($Sprite, "modulate", Color(1, 1, 1, 0), Color(1, 1, 1, 1), 2.0, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()
	$CollisionShape2D.disabled = false