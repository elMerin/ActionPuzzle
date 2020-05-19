extends Area2D

var speedX = 0
var speedY = 0

func _ready():
	pass

func _process(delta):
	position.x += speedX*delta
	position.y += speedY*delta
	
	if(position.x < 4160 || position.x > 6240):
		queue_free()
		
	if(position.y < 6240 || position.y > 9600):
		queue_free()
		


func _on_bullet_area_entered(area):
	if area.is_in_group("playerHitbox"):
		get_tree().get_root().get_node("Node").hits += 1
		print(get_tree().get_root().get_node("Node").hits)
