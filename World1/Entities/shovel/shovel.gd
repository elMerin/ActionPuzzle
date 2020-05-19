extends Area2D

var speed = 1
var speedX = 0
var speedY = 0
var rotationDegrees = 0
var scaleChangeX = 0
var scaleChangeY = 0
var follower = false

func _ready():
	var tween = Tween.new()
	tween.set_name("Tween")
	add_child(tween)
	pass

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
				
			
	if(follower):
		var direction = (get_tree().get_root().get_node("Node/YSort/Player").position - position).normalized()
		position = position + direction * speed	

func _on_Shovel_area_entered(area):
	if area.is_in_group("playerHitbox"):
		if !get_tree().get_root().get_node("Node/YSort/Player").playerHit:		
			get_tree().get_root().get_node("Node").hits += 1
			if get_tree().get_root().get_node("Node").hits < 6:
				get_tree().get_root().get_node("Node/YSort/Player").playerHit()		

func timeout():	
	$Tween.interpolate_property($Sprite, "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), 2.0, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()
	$CollisionShape2D.disabled = true
	$CollisionShape2D2.disabled = true
	$CollisionShape2D3.disabled = true
	$CollisionShape2D4.disabled = true

