extends CanvasLayer

var length = 0 #length of string of current page
var page = 0 #which page of current dialogue is active 
var whichDialogue = 0 #which choice player chose with buttons
var whichDialoguePlaying = 0 #which dialogue is currently playing
var pages = [] #current set of dialogue
var letters = ["Sometimes everything feels WRONG, you know?","The towers seem to help against it."] #next set of dialogue
var playing #boolean thats true if dialogue is playing
var choiceActive = false #if choice active
var texture = preload("res://icon.png") #placeholder
var timesApproached = 0 #number of times character has been talked to
var keyTakenDead = false
var keyTakenAlive = false
var textPositionWithSprite = Vector2(230,440)
var textPositionWithoutSprite = Vector2(60,440)

func _process(delta):
	pass
	
func start():
	timesApproached += 1
		
	
	
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
	match timesApproached:
		1:
			letters = ["I'm taking a rest here, you can go on."]
		2:
			letters = ["For all we know, everything out there\ncould be fucked as well."]
		3:	
			letters = ["Whatever's out there, try and look\non the bright side.", "It's all relative anyways."]
		_:
			letters = ["See you later."]	
			
	
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
