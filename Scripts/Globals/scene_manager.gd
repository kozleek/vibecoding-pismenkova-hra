extends Node

# Funkce pro bezpečné přepínání scén
func goto_scene(path: String) -> void:
	# Ujistíme se, že Godot má aktivní strom scén
	if get_tree().get_current_scene() != null:
		# Vlastní logika pro předání dat nebo animace přechodu (zde vynecháno)
		pass 
		
	# Přepnutí scény
	var error = get_tree().change_scene_to_file(path)
	if error != OK:
		print("Chyba při načítání scény: ", path)
