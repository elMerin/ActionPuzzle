extends CanvasLayer

var length = 0 #length of string of current page
var page = 0 #which page of current dialogue is active
var whichDialogue = 0 #which choice player chose with buttons
var whichDialoguePlaying = 0 #which dialogue is currently playing
var pages = [] #current set of dialogue
var letters = ["The embankment is blocking the flow of the river."]
var playing #boolean thats true if dialogue is playing
var choiceActive = false #if choice active
var river = preload("res://images/river.png")
var towerOn = preload("res://World1/Entities/tower/tower.png")
var riverFreed = false

func _process(delta):
	pass

func start():
	
	if(get_node("../..").shovelTaken):
		letters = ["You dig up the dirt wall blocking the river."]
		get_node("../CollisionShape2D").queue_free()
		get_node("..").remove_from_group("dialogue")
		get_node("../waterClot").visible = false
		get_node("../river").visible = true
		get_node("../../AnimationPlayer").play("watermill")
		get_node("../../YSort/tower2/Sprite").set_texture(towerOn)
		riverFreed = true

func display_text():
	
	start()
	pages = letters	

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
	if whichDialogue == 0:
		get_tree().get_root().get_node("Node/YSort/Player").position = Vector2(-2465.57666,7953.019531)
		finish()
		return
	else:
		choiceActive = false
	turnPage()
	
	
func on_button_pressed2():
	choiceActive = false
	turnPage()

