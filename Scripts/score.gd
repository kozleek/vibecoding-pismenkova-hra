class_name Score
extends HBoxContainer

@onready var team1_button: Button = $Team1
@onready var team2_button: Button = $Team2
@onready var team1_score_label: Label = $Team1/Score
@onready var team2_score_label: Label = $Team2/Score

var scoring_enabled: bool = false
var current_points_to_add: int = 0
var team1_scored: bool = false  # Zda už Team1 získal body v aktuálním bodování
var team2_scored: bool = false  # Zda už Team2 získal body v aktuálním bodování

func _ready() -> void:
	disable_scoring()
	update_display()
	update_visibility()

func _input(event: InputEvent) -> void:
	# Přičítání bodů pomocí klávesových zkratek
	if event.is_action_pressed("team1_score"):
		add_points_to_team1()
		get_viewport().set_input_as_handled()
	elif event.is_action_pressed("team2_score"):
		add_points_to_team2()
		get_viewport().set_input_as_handled()

# ========================
# Veřejné funkce
# ========================

## Povolí přičítání bodů a nastaví hodnotu bodů, které se přičtou při kliknutí
func enable_scoring(points: int) -> void:
	# Pokud není zobrazování bodů povoleno, nepovoluji scoring
	if not Settings.is_points_visible:
		print("[Score] Skorování není povoleno - zobrazování bodů je vypnuto")
		return

	scoring_enabled = true
	current_points_to_add = points
	team1_scored = false
	team2_scored = false
	_update_buttons_state()
	print("[Score] Skorování povoleno, Body: ", points)

## Zakáže přičítání bodů
func disable_scoring() -> void:
	scoring_enabled = false
	current_points_to_add = 0
	team1_scored = false
	team2_scored = false
	_update_buttons_state()
	print("[Score] Skorování zakazáno")

## Přičte body týmu 1
func add_points_to_team1() -> void:
	if not scoring_enabled or team1_scored:
		print("[Score] Team 1: Body nelze přidat")
		return

	Settings.team1_score += current_points_to_add
	team1_scored = true
	update_display()
	_update_buttons_state()
	UserData.save_settings()
	print("[Score] Team 1: +", current_points_to_add, " b. Score: ", Settings.team1_score)

	# Vizuální efekt
	if Visuals:
		Visuals.pop_animation(team1_button, 1.3, 0.1)

## Přičte body týmu 2
func add_points_to_team2() -> void:
	if not scoring_enabled or team2_scored:
		print("[Score] Team 2: Body nelze přidat")
		return

	Settings.team2_score += current_points_to_add
	team2_scored = true
	update_display()
	_update_buttons_state()
	UserData.save_settings()
	print("[Score] Team 2: +", current_points_to_add, " b. Score: ", Settings.team2_score)

	# Vizuální efekt
	if Visuals:
		Visuals.pop_animation(team2_button, 1.3, 0.1)

## Aktualizuje zobrazení skóre
func update_display() -> void:
	team1_score_label.text = str(Settings.team1_score)
	team2_score_label.text = str(Settings.team2_score)

## Resetuje skóre obou týmů
func reset_scores() -> void:
	Settings.team1_score = 0
	Settings.team2_score = 0
	update_display()
	UserData.save_settings()
	print("[Score] Skorování resetováno")

## Aktualizuje viditelnost podle nastavení
func update_visibility() -> void:
	visible = Settings.is_points_visible
	if not visible:
		disable_scoring()
	print("[Score] Viditelnost nastavena na: ", visible)

# ========================
# Privátní funkce
# ========================

## Aktualizuje stav tlačítek podle toho, zda je scoring povolený a zda už týmy bodovaly
func _update_buttons_state() -> void:
	# Team1 tlačítko - aktivní pouze pokud je scoring enabled a team1 ještě nebodoval
	var team1_enabled = scoring_enabled and not team1_scored
	team1_button.disabled = not team1_enabled
	team1_button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND if team1_enabled else Control.CURSOR_FORBIDDEN

	# Team2 tlačítko - aktivní pouze pokud je scoring enabled a team2 ještě nebodoval
	var team2_enabled = scoring_enabled and not team2_scored
	team2_button.disabled = not team2_enabled
	team2_button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND if team2_enabled else Control.CURSOR_FORBIDDEN
