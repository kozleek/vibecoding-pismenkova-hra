extends Node

@onready var answerContainer: PanelContainer = $"."
@onready var label: Label = $Label

var answers: Dictionary = {}
var current_answer: String = ""

func _ready() -> void:
	load_answers()
	hide_answer()

# ========================
# Načtení předgenerovaných odpovědí
# ========================

func load_answers() -> void:
	var path = Settings.ANSWERS_PATH
	if FileAccess.file_exists(path):
		var file = FileAccess.open(path, FileAccess.READ)
		var json_text = file.get_as_text()
		file.close()
		var json = JSON.new()
		if json.parse(json_text) == OK:
			answers = json.data

# ========================
# Získaní odpovědi pro slovo a písmeno
# ========================

func get_answer(subject: String, letter: String) -> String:
	if answers.has(subject):
		var subject_data = answers[subject]
		if subject_data.has(letter):
			return subject_data[letter]
	return ""
	
# ========================
# Zobrazení stavu
# ========================	

func show_answer(subject: String, letter: String) -> void:	
	current_answer = get_answer(subject, letter)
	if current_answer != "":
		answerContainer.show()
		label.text = current_answer
	else:
		hide_answer()

func hide_answer() -> void:
	answerContainer.hide()
	label.text = ""
