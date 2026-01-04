class_name Subject
extends Node

var subjects: Array = Settings.SUBJECTS
var current_index: int = 0

var current_subject_key: String = "" # Přejmenováno pro přehlednost (drží klíč, ne text)
var current_subject: String = ""

func _ready() -> void:	
	# Inicializace losovani
	draw_init()
	
	# Zobrazíme první položku
	update_visuals()	
	
# ========================
# Gettery pro hlavní aplikaci
# ========================

# Funkce, která vrací aktuální písmeno
func get_current_subject() -> String:
	return current_subject

# ========================
# Losování subjektu
# ========================

# Funkce, která inicializuje pole a zamicha ho a provede dalsi potrebne inicializace pro losovani
func draw_init() -> void:		
	subjects.shuffle()
	current_index = 0

# Funkce volaná časovačem - posouvá index v poli
func draw_subject() -> void:
	current_index += 1
	
	# Pokud jsme došli na konec balíčku, provedeme znovu inicializaci losovani
	if current_index >= subjects.size():
		draw_init()
		
	# Uložení aktualniho losovaneho subjektu...
	current_subject_key = subjects[current_index] as String
	current_subject = tr(current_subject_key)

	update_visuals()

# ========================
# Zobrazení informací
# ========================

func update_visuals() -> void:
	pass
	
# ========================
# Náhodné hodnoty
# ========================

# Vrací náhodný subject z pole všech subjektů
# Neefektivní při volání v timeru, ale pro jeden náhodný subject je to ok.
func get_random_letter() -> String:
	var random_subject_key = subjects.pick_random() as String
	if random_subject_key.is_empty():
		return ""
	else:
		return tr(random_subject_key)
