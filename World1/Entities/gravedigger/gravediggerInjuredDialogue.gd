extends CanvasLayer

var length = 0 #length of string of current page
var page = 0 #which page of current dialogue is active
var whichDialogue = 0 #which choice player chose with buttons
var pages = [] #current set of dialogue
var letters = ["He is unconscious. \nOverexertion seems to have caused his arm to get severed.", "Do you want to want to patch up his stump?"]
var playing #boolean thats true if dialogue is playing
var choiceActive = false #if choice active
var dead = false


func _process(delta):
	pass

func start():
	
	if dead:
		return

	var button = Button.new()
	button.text = "yes"
	button.add_to_group(str(1)) 
	button.connect("pressed",self,"pressedYes")
	button.rect_size = Vector2(100,25)
	button.anchor_left = 0.4
	button.anchor_top = 0.87
	button.hide()
	button.name = "button"
	button.focus_neighbour_right = "../button2"
	add_child(button)

	var button2 = Button.new()
	button2.text = "no"
	button2.add_to_group(str(1))
	button2.connect("pressed",self,"pressedNo")
	button2.rect_size = Vector2(100,25)
	button2.anchor_left = 0.6
	button2.anchor_top = 0.87
	button2.hide()
	button2.name = "button2"
	button2.focus_neighbour_left = "../button"
	add_child(button2)

	


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
		showButtons()
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
		showButtons()

var patchedSprite = preload("res://World1/Entities/gravedigger/gravediggerPatched.png")
var injuredWithoutShovelSprite = preload("res://World1/Entities/gravedigger/gravediggerInjuredWithoutShovel.png")

func showButtons():
	for n in get_children():
		if n is Button:
			if n.is_in_group(str(page)):
				n.show()
				n.grab_focus()
				choiceActive = true

func pressedYes():
	get_node("../../..").gravediggerSaved = true
	get_parent().get_node("Sprite").set_texture(patchedSprite)
	if !get_node("../../..").shovelTaken:
		if(get_node("../../controlPanel/Dialogue").switchedPower):
			pages.append("You prevent further blood loss and take the shovel.\n(You can use it with F) You also find a key.")
			get_node("../../..").keyTaken = true
		else:
			pages.append("You prevent further blood loss and take the shovel. \n(You can use it with F)")
		get_node("../../..").shovelTaken = true
	choiceActive = false
	turnPage()
	letters = ["There's a chance he'll survive."]
	
func pressedNo():
	get_parent().get_node("Sprite").set_texture(injuredWithoutShovelSprite)
	if !get_node("../../..").shovelTaken:
		if(get_node("../../controlPanel/Dialogue").switchedPower):
			pages.append("You take the shovel (You can use it with F) \nYou also find a key in his pocket.")
			get_node("../../..").keyTaken = true
		else:
			pages.append("You take the shovel (You can use it with F) and leave.")
		get_node("../../..").shovelTaken = true
	choiceActive = false
	turnPage()
	letters = ["He is unconscious. \nOverexertion seems to have caused his arm to get severed.", "Do you want to want to patch up his stump?"]



