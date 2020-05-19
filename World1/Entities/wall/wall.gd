extends StaticBody2D

func _ready():
	pass

func fadeOut():
	$CollisionShape2D.set_deferred("disabled",true)
	$Tween.interpolate_property($ColorRect, "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), 2.0, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()
	