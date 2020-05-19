extends "shovel.gd"

func _process(delta):
	position.x += speedX*delta
	position.y += speedY*delta
	rotation_degrees += rotationDegrees*delta
	scale.x += scaleChangeX*delta
	scale.y += scaleChangeY*delta
	
	
	if(position.x > -2461.557129+1500 || position.x < -2461.557129-1500):
		queue_free()
		
	if(position.y > 7643.289063+1500 || position.y < 7643.289063-1500):
		queue_free()
		
	if(!get_tree().get_root().get_node("Node").isGravediggerFight):
		queue_free()

	if position.y >= 7950 && speedY != 0:
			speedY = 0
			var timer = Timer.new()
			timer.connect("timeout",self,"timeout") 
			add_child(timer) 
			timer.set_wait_time(2)
			timer.one_shot = true
			timer.start() 
			
func _on_Shovel_area_entered(area):
	if area.is_in_group("playerHitbox"):
		if !get_tree().get_root().get_node("Node/YSort/Player").playerHit:
			get_tree().get_root().get_node("Node").hits += 6
			
func timeout():	
	$Tween.interpolate_property($Sprite, "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), 2.0, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()
	$CollisionShape2D.disabled = true
	$CollisionShape2D2.disabled = true
	$CollisionShape2D3.disabled = true
	$CollisionShape2D4.disabled = true