extends CanvasLayer

var length = 0 #length of string of current page
var page = 0 #which page of current dialogue is active 
var whichDialogue = 0 #which choice player chose with buttons
var whichDialoguePlaying = 0 #which dialogue is currently playing
var pages = [] #current set of dialogue
var letters = ["Hello there, my name is Godot.\nDo you want a sprite?"] #next set of dialogue
var playing #boolean thats true if dialogue is playing
var choiceActive = false #if choice active
var texture = preload("res://icon.png") #placeholder

func _process(delta):
	pass
	
func start():
	
		var whichDialoguePlaying = 0
		var button = Button.new()
		button.text = "yes"
		button.add_to_group(str(0)) 
		button.connect("pressed",self,"on_button_pressed")
		button.rect_size = Vector2(100,25)
		button.anchor_left = 0.4
		button.anchor_top = 0.87
		button.hide()
		add_child(button)
	
		var button2 = Button.new()
		button2.text = "no"
		button2.add_to_group(str(0))
		button2.connect("pressed",self,"on_button_pressed2")
		button2.rect_size = Vector2(100,25)
		button2.anchor_left = 0.6
		button2.anchor_top = 0.87
		button2.hide()
		add_child(button2)
	
	
	
func display_text():
	
	pages = letters
	
	start()
					
	$Timer.start()
	playing = true

func turnPage():
	
	if !playing :	#turns to next page, exits dialogue, or stays on same page
		if page+1 > pages.size()-1 && !choiceActive: #exits dialogue
			finish()
			return false
		elif !choiceActive: #turns to next page
			for n in get_children():
				if n is Button:
					if n.is_in_group(str(page)):
						n.queue_free()
			$Timer.start()
			length = 0
			page += 1
			playing = true
			return true
		else: #stays on same page (for when there is a choice to make or something)
			return true
	elif playing: #completes page and shows buttons/choices
		for n in get_children():
				if n is Button && whichDialogue == 0:
					if n.is_in_group(str(page)):
						n.show()
						choiceActive = true
		$"textbox/Label".text = pages[page]
		playing = false
		$Timer.stop()
		return true
	
	
func finish(): #cleanup function for exiting dialogue
	for n in get_children():
				if n is Button:
					if n.is_in_group(str(page)):
						choiceActive = false
						n.queue_free()
	$Timer.stop()
	playing = false
	$"textbox/Label".text = ""
	pages = []
	page = 0
	length = 0
	get_parent().dialogue_hide()
	get_tree().get_root().get_node("Node/YSort/Player").inDialogue = false
	get_tree().get_root().get_node("Node/YSort/Player/DialogueDetector/CollisionShape2D").disabled = true
	
func _on_Timer_timeout(): #for text animation
	if length < pages[page].length()+1:	#advances text animation
		$"textbox/Label".text = pages[page].substr(0,length)
		length += 1
	else: #if text is done animating
		playing = false
		for n in get_children():
				if n is Button:
					if n.is_in_group(str(page)):
						n.show()
						choiceActive = true	
						
func on_button_pressed():
	if whichDialogue == 0 && get_tree().get_root().get_node("Node/YSort/Player/Inventory").hasItem("apple"):
		if pages.has("Bring me an apple first!"):
			pages.remove("Bring me an apple first!")  
		var sprite = Sprite.new()
		sprite.texture = texture
		sprite.position = Vector2(200,200)
		get_tree().get_root().get_node("Node").get_node("YSort").add_child(sprite)
		pages.append("There you have it")
		get_tree().get_root().get_node("Node/YSort/Player/Inventory").removeItem("apple")
		letters = ["Already spawned it for you. \n Go away!", "Begone!!"]
		whichDialogue = 1 
	else:
		if !pages.has("Bring me an apple first!"):
			pages.append("Bring me an apple first!")  	
	choiceActive = false
	turnPage()
	
	
func on_button_pressed2():
	if pages.has("Bring me an apple first!"):
			pages.remove("Bring me an apple first!")  
	pages.append(">:(")  
	letters = ["You said you didn't want it. \n Go away!", "Begone!!"] 
	whichDialogue = 2
	choiceActive = false
	turnPage()
