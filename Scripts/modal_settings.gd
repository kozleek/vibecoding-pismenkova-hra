extends PanelContainer

# Odkazy na checkboxy v nastavení
@onready var check_sound: CheckButton = $CenterContainer/Panel/MarginContainer/VBoxContainer/SettingsContainer/CheckSound
@onready var check_autostop: CheckButton = $CenterContainer/Panel/MarginContainer/VBoxContainer/SettingsContainer/CheckAutostop
@onready var check_points: CheckButton = $CenterContainer/Panel/MarginContainer/VBoxContainer/SettingsContainer/CheckPoints
@onready var check_round: CheckButton = $CenterContainer/Panel/MarginContainer/VBoxContainer/SettingsContainer/CheckRound
@onready var check_no_repeat: CheckButton = $CenterContainer/Panel/MarginContainer/VBoxContainer/SettingsContainer/CheckNoRepeat

# Flag indikující, zda došlo ke změně nastavení (při zavření dialogu se reloadne scéna)
var settings_changed: bool = false


# ========================
# Inicializace a otevření dialogu
# ========================

# Synchronizuje stav checkboxů s aktuálním nastavením
# Používá set_pressed_no_signal aby se nevyvolaly toggle callbacky
func _sync_ui_with_settings() -> void:
	check_sound.set_pressed_no_signal(Settings.is_sound_enabled)
	check_autostop.set_pressed_no_signal(Settings.is_autostop_enabled)
	check_points.set_pressed_no_signal(Settings.is_points_visible)
	check_round.set_pressed_no_signal(Settings.is_round_enabled)
	check_no_repeat.set_pressed_no_signal(Settings.is_no_repeat_enabled)

# Otevře dialog s nastavením
# Synchronizuje UI s aktuálním stavem a zobrazí modal
func open() -> void:
	_sync_ui_with_settings()
	show()

# ========================
# Callback funkce pro změny nastavení
# ========================

# Helper pro uložení změny nastavení
# Nastaví flag pro reload scény a uloží do user data
func _save_setting_change() -> void:
	UserData.save_settings()
	settings_changed = true

# Callback pro změnu nastavení zvuku
func _on_check_sound_toggled(toggled_on: bool) -> void:
	Settings.is_sound_enabled = toggled_on
	_save_setting_change()

# Callback pro změnu automatického zastavení
func _on_check_autostop_toggled(toggled_on: bool) -> void:
	Settings.is_autostop_enabled = toggled_on
	_save_setting_change()

# Callback pro změnu viditelnosti bodů
# Okamžitě aktualizuje UI (score komponenta a body u písmen)
func _on_check_points_toggled(toggled_on: bool) -> void:
	Settings.is_points_visible = toggled_on
	_save_setting_change()

	# Okamžitá aktualizace viditelnosti score komponenty
	var score = get_tree().current_scene.get_node_or_null("Menu/HBoxContainer/HBoxContainerCenter")
	if score:
		if score.has_method("update_visibility"):
			score.update_visibility()
		else:
			push_warning("[ModalSettings] Score component missing update_visibility() method")
	else:
		push_warning("[ModalSettings] Score component not found at expected path")

	# Okamžité skrytí/zobrazení bodů u písmen
	var letter = get_tree().current_scene.get_node_or_null("MarginContainer/VBoxContainer/Letter")
	if letter:
		if toggled_on:
			if letter.has_method("points_show"):
				letter.points_show()
			else:
				push_warning("[ModalSettings] Letter component missing points_show() method")
		else:
			if letter.has_method("points_hide"):
				letter.points_hide()
			else:
				push_warning("[ModalSettings] Letter component missing points_hide() method")
	else:
		push_warning("[ModalSettings] Letter component not found at expected path")


# Callback pro změnu zapnutí/vypnutí kol
func _on_check_round_toggled(toggled_on: bool) -> void:
	Settings.is_round_enabled = toggled_on
	_save_setting_change()

# Callback pro změnu herního módu "Bez opakování"
func _on_check_no_repeat_toggled(toggled_on: bool) -> void:
	Settings.is_no_repeat_enabled = toggled_on
	_save_setting_change()

# ========================
# Ovládání dialogu
# ========================

# Zachytává ESC klávesu pro zavření dialogu
func _input(event: InputEvent) -> void:
	if visible and event.is_action_pressed("ui_cancel"):
		_close()

# ========================
# Callback funkce tlačítek
# ========================

# Callback pro tlačítko reset skóre
# Vynuluje všechna skóre přes score komponentu
func _on_button_score_reset_pressed() -> void:
	var score = get_tree().current_scene.get_node_or_null("Menu/HBoxContainer/HBoxContainerCenter")
	if score:
		if score.has_method("reset_scores"):
			score.reset_scores()
			print("[ModalSettings] Skóre bylo vynulováno")
		else:
			push_warning("[ModalSettings] Score component missing reset_scores() method")
	else:
		push_warning("[ModalSettings] Score component not found for reset")

# Callback pro tlačítko zavřít
func _on_button_close_pressed() -> void:
	_close()

# Zavře dialog s nastavením
# Pokud došlo ke změně nastavení, reloadne celou scénu
func _close() -> void:
	hide()
	get_tree().paused = false

	# Pokud došlo ke změnám, je potřeba reload scény (kvůli aktualizaci UI)
	if settings_changed:
		settings_changed = false
		get_tree().reload_current_scene()
