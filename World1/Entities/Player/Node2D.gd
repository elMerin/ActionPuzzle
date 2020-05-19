extends Node2D

#player functionality for world 1

func _on_DialogueDetector_body_entered(body):
	if !get_parent().inDialogue:
		if body.is_in_group("dialogue"):
			body.initiateDialogue()
			get_parent().inDialogue = true
			get_parent().body = body
		elif body.is_in_group("item"):
			get_node("../Inventory").addItem(body)
			body.visible = false
			body.get_node("CollisionShape2D").disabled = true
		
		


func _on_DialogueDetector_body_exited(body):
	if get_parent().inDialogue && body.is_in_group("dialogue"):
		get_parent().inDialogue = false
		get_parent().get_node('DialogueDetector/CollisionShape2D').set_deferred("disabled",true)


func _on_deathArea_body_entered(body):
	if body.is_in_group("player"):
		get_node("../../../deathArea").initiateDialogue()
		get_parent().inDialogue = true
		get_parent().movableDialogue = true
		get_parent().body = get_node("../../../deathArea")

