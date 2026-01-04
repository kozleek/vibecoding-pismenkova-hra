class_name Subject
extends Node

@onready var label: Label = $Label

var subjects: Array = []
var current_index: int = 0

var current_subject_key: String = "" # Drží klíč pro překlad (např. "SUBJ_CITY")
var current_subject: String = ""     # Drží přeložený text (např. "Město")

func _ready() -> void:
	# Načteme data ze Settings
	subjects = Settings.SUBJECTS
	
	# Inicializace pole (zamíchání na začátku)
	shuffle_subjects()
	
	# Nastavíme výchozí stav
	update_visuals()

# ========================
# Gettery pro hlavní aplikaci
# ========================

func get_current_subject() -> String:
	return current_subject

# ========================
# Logika losování
# ========================

# Inicializuje/zamíchá pole (volat jen při startu nebo ručním resetu)
func shuffle_subjects() -> void:		
	subjects.shuffle()
	current_index = 0

# Funkce volaná externě z hlavního controlleru přes časovač
func draw_subject() -> void:
	if subjects.size() == 0:
		return
		
	# Posun indexu s automatickým návratem na nulu (modulo)
	current_index = (current_index + 1) % subjects.size()
	
	update_visuals()

# ========================
# Zobrazení stavu
# ========================

func update_visuals() -> void:
	if subjects.size() > 0:
		# Uložení aktuálního klíče
		current_subject_key = subjects[current_index] as String
		# Uložení přeloženého textu (tr = translation)
		current_subject = tr(current_subject_key)
	
	# Zde můžeš přidat aktualizaci Labelu, pokud ho tento uzel má, např.:
	label.text = current_subject

# ========================
# Náhodné hodnoty
# ========================

# Vrací náhodný přeložený subjekt (bez ovlivnění aktuálního indexu)
func get_random_subject() -> String:
	var random_subject_key = subjects.pick_random() as String
	if random_subject_key.is_empty():
		return ""
	else:
		return tr(random_subject_key)
