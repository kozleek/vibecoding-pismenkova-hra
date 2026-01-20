extends Node

# Odkazy na UI prvky
@onready var answer_container: PanelContainer = $"."
@onready var label: Label = $MarginContainer/Label

# Dictionary s předgenerovanými odpověďmi ve struktuře: { "SUB_KEY": { "A": "odpověď", "B": ... } }
var answers: Dictionary = {}

func _ready() -> void:
	_load_answers()
	hide_answer()

# ========================
# Načtení předgenerovaných odpovědí
# ========================

func _load_answers() -> void:
	var path = Settings.ANSWERS_PATH

	# Kontrola existence souboru s odpověďmi
	if not FileAccess.file_exists(path):
		push_warning("Answer file not found at path: %s" % path)
		return

	# Pokus o otevření souboru - může selhat kvůli oprávněním nebo jiným IO problémům
	var file = FileAccess.open(path, FileAccess.READ)
	if file == null:
		push_error("Failed to open answer file: %s. Error: %s" % [path, FileAccess.get_open_error()])
		return

	# Načtení celého obsahu souboru jako text
	var json_text = file.get_as_text()
	file.close()

	# Parsování JSON dat
	var json = JSON.new()
	var parse_result = json.parse(json_text)
	if parse_result != OK:
		push_error("Failed to parse answer JSON. Error at line %d: %s" % [json.get_error_line(), json.get_error_message()])
		return

	# Validace typu - root musí být Dictionary
	if typeof(json.data) != TYPE_DICTIONARY:
		push_error("Answer JSON root must be a Dictionary, got: %s" % type_string(typeof(json.data)))
		return

	# Úspěšné načtení - uložení dat do globální proměnné
	answers = json.data

# ========================
# Získání odpovědi pro kategorii a písmeno
# ========================

func get_answer(subject: String, letter: String) -> String:
	# Vyhledání kategorie v načtených datech
	if answers.has(subject):
		var subject_data = answers[subject]
		# Vyhledání písmena v rámci kategorie
		if subject_data.has(letter):
			return subject_data[letter]
	# Pokud odpověď neexistuje, vrací prázdný řetězec
	return ""
	
# ========================
# Zobrazení a skrytí odpovědi
# ========================

func show_answer(subject: String, letter: String) -> void:
	# Získání odpovědi pro zadanou kategorii a písmeno
	var answer_text = get_answer(subject, letter)
	if answer_text != "":
		# Pokud odpověď existuje, zobrazíme kontejner a nastavíme text
		answer_container.show()
		label.text = answer_text
	else:
		# Pokud odpověď neexistuje, schováme kontejner
		hide_answer()

func hide_answer() -> void:
	# Skrytí kontejneru s odpovědí a vyčištění textu
	answer_container.hide()
	label.text = ""
