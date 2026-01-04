extends Node

func get_random_item(items: Array) -> String:
	var random_item = items.pick_random() as String
	if random_item.is_empty():
		return ""
	else:
		return random_item
