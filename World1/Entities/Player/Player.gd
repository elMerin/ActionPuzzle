extends KinematicBody2D

export (int) var speed = 200

var velocity = Vector2()
var dodging = false
var rollable = true
var dialogueBox
var direction
var inDialogue = false
var i = 0
var body
var inInventory = false
var movableDialogue = false
var justExited = false
var playerHit = false
var playerDead = false
var attacking = false

func _ready():
	var tween = Tween.new()
	tween.set_name("tween")
	add_child(tween)
	
	loadd()	
	
	if direction == "right":
		$AnimatedSprite.flip_h = false
		$AnimatedSprite.play("CharRight")
				
	elif direction == "left":
		$AnimatedSprite.flip_h = true
		$AnimatedSprite.play("CharRight")
			
	elif direction == "down"	:
		$AnimatedSprite.play("CharDown")
		
	elif direction == "up":
		$AnimatedSprite.play("CharUp")	
						
	elif direction == "downRight":
		$AnimatedSprite.flip_h = false
		$AnimatedSprite.play("CharDownRight")
		
	elif direction == "downLeft":
		$AnimatedSprite.flip_h = true
		$AnimatedSprite.play("CharDownRight")
			
	elif direction == "upRight"	:
		$AnimatedSprite.flip_h = false
		$AnimatedSprite.play("CharUpRight")
		
	elif direction == "upLeft":
		$AnimatedSprite.flip_h = true
		$AnimatedSprite.play("CharUpRight")	
	
	
func _input(event):
	

	if !dodging && event.is_action_pressed("movement") && (!inDialogue || movableDialogue):
		$AnimatedSprite.set_frame(1)
	
	#if event.is_action_pressed("inventory") && !inDialogue:	
	#	$"Inventory/ColorRect".visible = !$"Inventory/ColorRect".visible
	#	inInventory = $"Inventory/ColorRect".visible
	
	if event.is_action_pressed("attack") && !inInventory && !inDialogue && !attacking && !dodging && get_node("../..").shovelTaken:	
		var attackTimer = Timer.new()
		attackTimer.connect("timeout",self,"attackFin") 
		add_child(attackTimer) 
		attackTimer.set_wait_time(0.5)
		attackTimer.one_shot = true
		attackTimer.start() 
	
		attacking = true
		$"attackDetector/CollisionShape2D".disabled = false
		$"attackDetector/CollisionShape2D/Sprite".visible = true
		match direction:
			"up":
				$"attackDetector/CollisionShape2D".position = Vector2(0,-20)
				$"attackDetector/CollisionShape2D".rotation_degrees = 0
			"down":
				$"attackDetector/CollisionShape2D".position = Vector2(0,30)
				$"attackDetector/CollisionShape2D".rotation_degrees = 180
			"downRight":
				$"attackDetector/CollisionShape2D".position = Vector2(20,23)
				$"attackDetector/CollisionShape2D".rotation_degrees = 135
			"downLeft":
				$"attackDetector/CollisionShape2D".position = Vector2(-20,23)
				$"attackDetector/CollisionShape2D".rotation_degrees = 225
			"upRight":
				$"attackDetector/CollisionShape2D".position = Vector2(20,-17)
				$"attackDetector/CollisionShape2D".rotation_degrees = 45
			"upLeft":
				$"attackDetector/CollisionShape2D".position = Vector2(-20,-17)
				$"attackDetector/CollisionShape2D".rotation_degrees = 315
			"left":
				$"attackDetector/CollisionShape2D".position = Vector2(-23,7)
				$"attackDetector/CollisionShape2D".rotation_degrees = 270
			"right":
				$"attackDetector/CollisionShape2D".position = Vector2(23,7)
				$"attackDetector/CollisionShape2D".rotation_degrees = 90
				

	
	if event.is_action_pressed("dialogue") && !inInventory:	
		
		if justExited:
			justExited = false
		
		if inDialogue:
			body.get_node("Dialogue").turnPage()	
			return
			
		if movableDialogue || justExited:
			return
	
		i = 1
		$"DialogueDetector/CollisionShape2D".disabled = false
		
				
		if !inDialogue:
			match direction:
				"up":
					$"DialogueDetector/CollisionShape2D".position = Vector2(0,1)
					$"DialogueDetector/CollisionShape2D".rotation_degrees = 0
				"down":
					$"DialogueDetector/CollisionShape2D".position = Vector2(0,13)
					$"DialogueDetector/CollisionShape2D".rotation_degrees = 0
				"downRight":
					$"DialogueDetector/CollisionShape2D".position = Vector2(8.5,12)
					$"DialogueDetector/CollisionShape2D".rotation_degrees = -45
				"downLeft":
					$"DialogueDetector/CollisionShape2D".position = Vector2(-7.5,12)
					$"DialogueDetector/CollisionShape2D".rotation_degrees = 45
				"upRight":
					$"DialogueDetector/CollisionShape2D".position = Vector2(8.5,2)
					$"DialogueDetector/CollisionShape2D".rotation_degrees = 45
				"upLeft":
					$"DialogueDetector/CollisionShape2D".position = Vector2(-7.5,2)
					$"DialogueDetector/CollisionShape2D".rotation_degrees = -45
				"left":
					$"DialogueDetector/CollisionShape2D".position = Vector2(-10,7)
					$"DialogueDetector/CollisionShape2D".rotation_degrees = 90
				"right":
					$"DialogueDetector/CollisionShape2D".position = Vector2(11,7)
					$"DialogueDetector/CollisionShape2D".rotation_degrees = 90
					
		
	
	if event.is_action_pressed("roll") && rollable && (velocity.x != 0 || velocity.y != 0):
		dodging = true
		rollable = false
		
		

func get_input():

	if attacking:
		velocity = velocity.normalized()*0
		$AnimatedSprite.set_frame(0)
		$AnimatedSprite.stop()
		return

	if playerHit || playerDead:
		velocity = velocity.normalized()*0
		$AnimatedSprite.set_frame(0)
		$AnimatedSprite.stop()
		return

	if Input.is_action_pressed("shift"):
		$AnimatedSprite.frames.set_animation_speed("CharDown",8)
		$AnimatedSprite.frames.set_animation_speed("CharDownRight",8)
		$AnimatedSprite.frames.set_animation_speed("CharRight",8)
		$AnimatedSprite.frames.set_animation_speed("CharUp",8)
		$AnimatedSprite.frames.set_animation_speed("CharUpRight",8)
		speed = 400
	else:
		$AnimatedSprite.frames.set_animation_speed("CharDown",5)
		$AnimatedSprite.frames.set_animation_speed("CharDownRight",5)
		$AnimatedSprite.frames.set_animation_speed("CharRight",5)
		$AnimatedSprite.frames.set_animation_speed("CharUp",5)
		$AnimatedSprite.frames.set_animation_speed("CharUpRight",5)
		speed = 200

	var s = speed
	
	if (!dodging || (velocity.x == 0 && velocity.y == 0)) && (!inDialogue || movableDialogue) :
		velocity = Vector2()
		if Input.is_action_pressed('ui_right'):
			velocity.x += 1	
		if Input.is_action_pressed('ui_left'):
			velocity.x -= 1
		if Input.is_action_pressed('ui_down'):
			velocity.y += 1
		if Input.is_action_pressed('ui_up'):
			velocity.y -= 1
			
		if velocity.x == 1 && velocity.y == 0:
			$AnimatedSprite.flip_h = false
			$AnimatedSprite.play("CharRight")
			direction = "right"	
		elif velocity.x == -1 && velocity.y == 0:
			$AnimatedSprite.flip_h = true
			$AnimatedSprite.play("CharRight")
			direction = "left"	
		elif velocity.x == 0 && velocity.y == 1:
			$AnimatedSprite.play("CharDown")
			direction = "down"	
		elif velocity.x == 0 && velocity.y == -1:
			$AnimatedSprite.play("CharUp")	
			direction = "up"				
		elif velocity.x == 1 && velocity.y == 1:
			$AnimatedSprite.flip_h = false
			$AnimatedSprite.play("CharDownRight")
			direction = "downRight"	
		elif velocity.x == -1 && velocity.y == 1:
			$AnimatedSprite.flip_h = true
			$AnimatedSprite.play("CharDownRight")
			direction = "downLeft"	
		elif velocity.x == 1 && velocity.y == -1:
			$AnimatedSprite.flip_h = false
			$AnimatedSprite.play("CharUpRight")
			direction = "upRight"	
		elif velocity.x == -1 && velocity.y == -1:
			$AnimatedSprite.flip_h = true
			$AnimatedSprite.play("CharUpRight")	
			direction = "upLeft"	
	elif !inDialogue && dodging:
		if velocity.x > 0 && velocity.y == 0:
			$AnimatedSprite.flip_h = false
			$AnimatedSprite.play("RollRight")	
		elif velocity.x < 0 && velocity.y == 0:
			$AnimatedSprite.flip_h = true
			$AnimatedSprite.play("RollRight")
		elif velocity.x == 0 && velocity.y > 0:
			$AnimatedSprite.play("RollDown")
		elif velocity.x == 0 && velocity.y < 0:
			$AnimatedSprite.play("RollUp")				
		elif velocity.x > 0 && velocity.y > 0:
			$AnimatedSprite.flip_h = false
			$AnimatedSprite.play("RollDownRight")
		elif velocity.x < 0 && velocity.y > 0:
			$AnimatedSprite.flip_h = true
			$AnimatedSprite.play("RollDownRight")
		elif velocity.x > 0 && velocity.y < 0:
			$AnimatedSprite.flip_h = false
			$AnimatedSprite.play("RollUpRight")
		elif velocity.x < 0 && velocity.y < 0:
			$AnimatedSprite.flip_h = true
			$AnimatedSprite.play("RollUpRight")	
		s = speed * 3
	else:
		s = 0
	
	velocity = velocity.normalized() * s
		
	if velocity.x == 0 && velocity.y == 0 || (inDialogue && !movableDialogue):
		
		if direction == "right" || direction == "left":
			$AnimatedSprite.play("CharRight")	
				
		elif direction == "downRight" || direction == "downLeft":
			$AnimatedSprite.play("CharDownRight")
			
		elif direction == "upRight" || direction == "upLeft" :
			$AnimatedSprite.play("CharUpRight")
			
		elif direction == "up":
			$AnimatedSprite.play("CharUp")
			
		elif direction == "down":
			$AnimatedSprite.play("CharDown")
						
		$AnimatedSprite.set_frame(0)
		$AnimatedSprite.stop()

func _physics_process(delta):
	get_input()
	if dodging:
		$"hitbox/CollisionShape2D".disabled = true
	else:
		$"hitbox/CollisionShape2D".disabled = false
	move_and_slide(velocity)
	if i == 1:
		i = 2
	elif i == 2:
		if(!inDialogue):
			$"DialogueDetector/CollisionShape2D".disabled = true
			i = 0

	
func savee(): #saves direction player is facing
	var path = "res://save.dat"
	var file = File.new()
	var err = file.open(path, File.WRITE)
	if err != OK:
		print("An error occurred")
		return
	file.store_var(direction)
	file.close()
	
func loadd(): #loads direction player is facing
	var path = "res://save.dat"
	var file = File.new()

	var err = file.open(path, File.READ)
	
	if err != OK:
		print("An error occurred")
		return

	direction = file.get_var()

	file.close()

func playerHit():
	get_tree().get_root().get_node("Node/playerHit").start()
	playerHit = true

func _on_playerHit_timeout():
	playerHit = false


func _on_playerDeath_timeout():
	position = Vector2(-322.870697,7241.362793)
	visible = true
	playerDead = false
	get_node("../gravedigger").show()
	$tween.interpolate_property(get_node("../../deathScreen"), "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), 2.0, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$tween.start()


func _on_CD_timeout():
	rollable = true

func _on_AnimatedSprite_animation_finished():
	if dodging:
		dodging = false
		$CD.start()

func attackFin():
	attacking = false
	$"attackDetector/CollisionShape2D/Sprite".visible = false
	$"attackDetector/CollisionShape2D".disabled = true

func _on_attackDetector_body_entered(body):
	
	if body.is_in_group("dam"):
		$Node2D._on_DialogueDetector_body_entered(body)
	
	if body.is_in_group("firer"):
		body.hitpoints -= 1
		if body.hitpoints <= 0:
			body.visible = false
			body.firing = false
			body.get_node("CollisionPolygon2D").disabled = true
			
			if body.is_in_group("group1"):
				for n in get_node("../..").get_children():
					if n.is_in_group("group1") && n.hitpoints > 0:
						n.firing = true
			if body.is_in_group("group2"):
				for n in get_node("../..").get_children():
					if n.is_in_group("group2") && n.hitpoints > 0:
						n.firing = true
			if body.is_in_group("group3"):
				for n in get_node("../..").get_children():
					if n.is_in_group("group3") && n.hitpoints > 0:
						n.firing = true


func _on_bulletsDeath_timeout():
	position = Vector2(5200,6000)
	visible = true
	playerDead = false
	get_node("../gravedigger").show()
	$tween.interpolate_property(get_node("../../deathScreen"), "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), 2.0, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$tween.start()
	for n in get_node("../..").get_children():
		if n.is_in_group("firer"):
			n.firing = false
			n.visible = true
			n.hitpoints = 4
			n.get_node("CollisionPolygon2D").disabled = false
			n.rotation = 0


