extends Node

var isWeird = false
const shovelScene = preload("res://World1/Entities/shovel/Shovel.tscn")
const bigShovel = preload("res://World1/Entities/shovel/bigShovel.tscn")
const expandShovel = preload("res://World1/Entities/shovel/expandShovel.tscn")
var spawnTimer = Timer.new()
var gravediggerReferenceX = -2461.557129
var gravediggerReferenceY = 7382.080078
var isGravediggerFight = false
var iteration = 0
var hits = 0
var gravediggerDefeated = false
var shovelTaken = false
var keyTaken = false
var gravediggerSaved = false
var slenderDead = false

func _ready():
	var tween = Tween.new()
	tween.set_name("tween")
	add_child(tween)
	$deathScreen.modulate = Color(1, 1, 1, 0)
	$deathScreen.visible = true

func _process(delta):
	if isGravediggerFight:
		if hits >= 6:
				playerDeathGravedigger()
				hits = 0
				iteration = 0
				spawnTimer.stop()
	else:
		if hits >= 20:
				playerDeathBullets()
				hits = 0
				iteration = 0
				spawnTimer.stop()
				for n in get_children():
					if n.is_in_group("firer"):
						n.firing = false
				
		
func playerDeathGravedigger():
	isGravediggerFight = false
	get_node("YSort/Player").visible = false
	get_node("YSort/Player").playerDead = true
	get_node("gdFightDeath").start()
	$tween.interpolate_property($deathScreen, "modulate", Color(1, 1, 1, 0), Color(1, 1, 1, 1), 2.0, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$tween.start()

func playerDeathBullets():
	get_node("YSort/Player").visible = false
	get_node("YSort/Player").playerDead = true
	get_node("bulletsDeath").start()
	$tween.interpolate_property($deathScreen, "modulate", Color(1, 1, 1, 0), Color(1, 1, 1, 1), 2.0, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$tween.start()


func startGravediggerFight():
	isGravediggerFight = true
	spawnTimer.connect("timeout",self,"timeout") 
	add_child(spawnTimer) 
	spawnTimer.set_wait_time(2)
	spawnTimer.start() 
	
func timeout():
	iteration += 1
	
	if iteration < 45:
		shovelWave()
	
	
	if iteration <= 3:
		spawnTimer.set_wait_time(2)
	elif iteration > 3 && iteration <= 6:
		spawnTimer.set_wait_time(1.75)
	elif iteration > 5:
		spawnTimer.set_wait_time(1.5)
	elif iteration >= 10:
		spawnTimer.set_wait_time(1.25)
	

	if iteration > 6 && iteration < 45:
		shovelWave2()
	
	if iteration == 10:
		bigShovel()
		
	if iteration == 20:
		rotatingShovel()
		
	if iteration == 25:
		$rotator1.timeout()
		var shovel = shovelScene.instance()
		shovel.position = Vector2(gravediggerReferenceX,gravediggerReferenceY-500)
		shovel.rotationDegrees =700
		shovel.follower = true
		shovel.name = "rotator2"
		shovel.speed = 1.75
		add_child(shovel)
	if iteration == 30:
		$rotator2.timeout()
		var shovel = shovelScene.instance()
		shovel.position = Vector2(gravediggerReferenceX-500,gravediggerReferenceY+250)
		shovel.rotationDegrees =700
		shovel.follower = true
		shovel.name = "rotator3"
		shovel.speed = 2
		var shovel2 = shovelScene.instance()
		shovel2.position = Vector2(gravediggerReferenceX+500,gravediggerReferenceY+250)
		shovel2.rotationDegrees =700
		shovel2.follower = true
		shovel2.name = "rotator4"
		add_child(shovel)
		add_child(shovel2)
		shovel2.speed = 1.7
	if iteration == 35:
		$rotator3.timeout()
		$rotator4.timeout()
		
	if iteration == 30:
		expandShovel()
	
	if iteration == 45:
		$YSort/gravediggerInjured.fadeIn()
		$YSort/door.fadeIn()
		spawnTimer.stop()
		gravediggerDefeated = true
		isGravediggerFight = false
		hits = 0	
		
		

func rotatingShovel():
	var shovel = shovelScene.instance()
	shovel.position = Vector2(gravediggerReferenceX,gravediggerReferenceY+1000)
	shovel.rotationDegrees =700
	shovel.follower = true
	shovel.name = "rotator1"
	shovel.speed = 1.5
	add_child(shovel)
	

var yposition = -100
	
func shovelWave():
	
	if(yposition == -100):
		yposition = -100+(150/2)
	else:
		yposition = -100
		
	for i in range(6):
		var shovel = shovelScene.instance()

		shovel.position = Vector2(gravediggerReferenceX-1000,gravediggerReferenceY+yposition)
		
		if iteration <= 3:
			shovel.speedX = 300	
		elif iteration > 3 && iteration <= 6:
			shovel.speedX = 350
		elif iteration > 5 && iteration <10:
			shovel.speedX = 400
		elif iteration >= 10:
			shovel.speedX = 500
		
		shovel.rotation_degrees = -90
		shovel.position.y += i*150
		add_child(shovel)

func shovelWave2():
	for i in range(6):
		var shovel = shovelScene.instance()
		shovel.position = Vector2(gravediggerReferenceX+1000,gravediggerReferenceY-100)
		
		if iteration < 10:
			shovel.speedX = -400
		elif iteration >= 10:
			shovel.speedX = -500
		shovel.rotation_degrees = 90
		shovel.position.y += i*150
		add_child(shovel)
		
func bigShovel():
	var shovel = bigShovel.instance()
	shovel.position = Vector2(gravediggerReferenceX,gravediggerReferenceY-1000)
	shovel.rotation_degrees = 90
	shovel.speedY = 60
	shovel.scale.x = 6
	shovel.scale.y = 6
	add_child(shovel)
		
  
func expandShovel():
	var shovel = expandShovel.instance()
	shovel.position = Vector2(gravediggerReferenceX,gravediggerReferenceY-1000)
	shovel.scaleChangeX = 0.5
	shovel.scaleChangeY = 0.5
	add_child(shovel)



func _on_teleporter_body_entered(body):
	if body.is_in_group("player"):
		body.position = Vector2(5200,5200) #teleport to location that makes sense
		


func _on_teleporter2_body_entered(body):
	if body.is_in_group("player"):
		body.position = Vector2(520,9600) #teleport to location that makes sense


func _on_group1Firers_body_entered(body):
	if body.is_in_group("player"):
		for n in get_children():
			if n.is_in_group("group1") && n.hitpoints > 0:
				n.firing = true



func _on_group2Firers_body_entered(body):
	if body.is_in_group("player"):
		for n in get_children():
			if n.is_in_group("group2") && n.hitpoints > 0:
				n.firing = true


func _on_group3Firers_body_entered(body):
	if body.is_in_group("player"):
		for n in get_children():
			if n.is_in_group("group3") && n.hitpoints > 0:
				n.firing = true


func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		if !slenderDead:
			get_node("YSort/slender").visible = false
			get_node("YSort/slender/CollisionShape2D").set_deferred("disabled",true)
			get_node("YSort/slender2").visible = true
			get_node("YSort/slender2/CollisionShape2D").set_deferred("disabled",false)
			get_node("slender?").queue_free()


func _on_end_body_entered(body):
	if body.is_in_group("player"):
		get_tree().change_scene("res://endingScreen.tscn")
