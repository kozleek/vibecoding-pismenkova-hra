class_name Letter
extends Node

@onready var background: Panel = $Background
@onready var label: Label = $Background/Label

var letters_and_points: Dictionary = Settings.LETTERS_AND_POINTS
var letters: Array = []
var current_index: int = 0

var current_letter: String = ""
var current_points: int = 0

func _ready() -> void:
	# Inicializujeme pole klíčů (písmen)
	letters = letters_and_points.keys()
	
	# Prvotní zamíchání a nastavení
	shuffle_letters()
	
	# Zobrazíme výchozí stav (index 0)
	update_visuals()

# ========================
# Gettery pro hlavní aplikaci
# ========================

func get_current_letter() -> String:
	return current_letter.to_upper()

func get_letters() -> Array:
	return letters

func get_current_points() -> int:
	return current_points

# ========================
# Logika losování
# ========================

# Pouze zamíchá pole a resetuje index, ale neaktualizuje vizuál (čistá data)
func shuffle_letters() -> void:
	letters.shuffle()
	current_index = 0

# Funkce volaná časovačem
func draw_letter() -> void:
	# 1. Posuneme index na další pozici (pomocí modulo pro automatický návrat na 0)
	current_index = (current_index + 1) % letters.size()
	
	# 2. Aktualizujeme data a vizuál pro tento NOVÝ index
	update_visuals()

# ========================
# Zobrazení stavu
# ========================

func update_visuals() -> void:
	# Nastavíme aktuální stav na základě aktuálního indexu
	if letters.size() > 0:
		current_letter = letters[current_index] as String
		current_points = get_random_points()
		
		# Aktualizace UI
		label.text = current_letter.to_upper()

# ========================
# Výpočty a pomocné funkce
# ========================

func get_scrabble_points() -> int:
	var letter_key = current_letter.to_lower()
	if letters_and_points.has(letter_key):
		return letters_and_points[letter_key]
	return 1

# Pokud bys chtěl úplně náhodné body (mimo Scrabble tabulku), jak jsi měl v původním kódu
func get_random_points() -> int:
	return randi_range(Settings.points_range.x, Settings.points_range.y)
