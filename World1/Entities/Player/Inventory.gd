extends CanvasLayer

var items = []


func addItem(item):
	items.append(item)
	for n in get_node("ColorRect/Container").get_children():
			if(n.text == ""):
				n.text = item.itemName
				break
	
func removeItem(itemName):
	for i in items:
		if i.itemName == itemName:
			items.erase(i)
			break
	for n in get_node("ColorRect/Container").get_children():
			if(n.text == itemName):
				n.text = ""
				break
				
func hasItem(item):
	for n in get_node("ColorRect/Container").get_children():
			if(n.text == item):
				return true
	return false

func _on_Button_pressed():
	removeItem($"ColorRect/Container/Button".text)


func _on_Button2_pressed():	
	if $"ColorRect/Container/Button2".get_child_count() > 0:
		print("button 2")


func _on_Button3_pressed():
	if $"ColorRect/Container/Button3".get_child_count() > 0:
		print("button 3")


func _on_Button4_pressed():
	if $"ColorRect/Container/Button4".get_child_count() > 0:
		print("button 4")


func _on_Button5_pressed():
	if $"ColorRect/Container/Button5".get_child_count() > 0:
		print("button 5")


func _on_Button6_pressed():
	if $"ColorRect/Container/Button6".get_child_count() > 0:
		print("button 6")


func _on_Button7_pressed():
	if $"ColorRect/Container/Button7".get_child_count() > 0:
		print("button 7")


func _on_Button8_pressed():
	if $"ColorRect/Container/Button8".get_child_count() > 0:
		print("button 8")


func _on_Button9_pressed():
	if $"ColorRect/Container/Button9".get_child_count() > 0:
		print("button 9")
