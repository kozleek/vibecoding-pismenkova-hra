extends Node

# ========================
# Obrazovka / Kamera
# ========================

# zatřesení obrazovkou
func screen_shake(target_node, intensity: float = 5.0, duration: float = 0.2, repeat: int = 5):
	var original_pos = target_node.position # nebo camera.position
	var tween = create_tween()
	
	# Zatřeseme obrazovkou několikrát
	for i in range(repeat):
		var random_offset = Vector2(randf_range(-intensity, intensity), randf_range(-intensity, intensity))
		tween.tween_property(target_node, "position", original_pos + random_offset, duration / repeat)
	
	# Vrátíme na původní pozici
	tween.tween_property(target_node, "position", original_pos, duration / repeat)

# ========================
# Animace
# ========================

# POP animace
func pop_animation(target_node: Control, factor: float = 1.4, duration: float = 0.2, repeat: int = 1):
	# Ujistěte se, že pivot bod je ve středu (aby se zvětšoval ze středu)
	target_node.pivot_offset = target_node.size / 2
	var tween = create_tween()
	
	for i in range(repeat):
		# Rychlé zvětšení na 120% během 0.1s
		tween.tween_property(target_node, "scale", Vector2(factor, factor), duration).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		# Návrat na 100%
		tween.tween_property(target_node, "scale", Vector2(1.0, 1.0), duration)

# ========================
# Pozadí a barvy
# ========================

# Funkce pro vygenerování a nastavení barvy
func change_background_color(target_node) -> void:
	var random_color = background_color_generator()
	
	# Vytvoříme nový styl pro pozadí (StyleBoxFlat je standardní styl pro plnou barvu)
	var style = StyleBoxFlat.new()
	style.bg_color = random_color
	
	# Přepíšeme styl panelu ('panel' je název vlastnosti ve Theme)
	target_node.add_theme_stylebox_override("panel", style)

# Funkce, která vrací náhodnou barvu v modelu HSV
func background_color_generator() -> Color:
	# Hue (Odstín): 
	# 0.75 je čistá fialová (270 stupňů)
	# 0.92 je sytá růžová (cca 330 stupňů)
	var h = randf_range(0.75, 0.92)
	
	# Saturation (Sytost): 0.6 až 1.0 (aby barva nebyla vybledlá)
	var s = randf_range(0.5, 0.9)
	
	# Value (Jas): 0.8 až 1.0 (aby barva byla jasná)
	var v = randf_range(0.5, 1.0)
	
	# Vytvoření barvy z HSV modelu
	return Color.from_hsv(h, s, v)
