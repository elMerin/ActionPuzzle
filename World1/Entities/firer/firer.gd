extends StaticBody2D

const bulletScene = preload("res://World1/Entities/firer/bullet/bullet.tscn")
export var fireWaitTime = 0.1
export var rotationSpeed = 2
export var hitpoints = 4
export var firing = false


func _ready():
	call_deferred("fireBullet")

func fireBullet():
	var spawnTimer = Timer.new()
	spawnTimer.connect("timeout",self,"timeout") 
	add_child(spawnTimer) 
	spawnTimer.set_wait_time(fireWaitTime)
	spawnTimer.start() 
	
	
func _process(delta):
	if firing:
		rotation += rotationSpeed*delta
	
func timeout():
	if firing:
		var bullet = bulletScene.instance()
		bullet.position = $barrel1.global_position
		bullet.speedX = cos(deg2rad(rotation_degrees-90))*500
		bullet.speedY = sin(deg2rad(rotation_degrees-90))*500
		get_node("..").add_child(bullet)
		
		var bullet2 = bulletScene.instance()
		bullet2.position = $barrel2.global_position
		bullet2.speedX = cos(deg2rad(rotation_degrees-90+180))*500
		bullet2.speedY = sin(deg2rad(rotation_degrees-90+180))*500
		get_node("..").add_child(bullet2)
	
	
