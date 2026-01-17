extends PanelContainer

@onready var check_sound: CheckButton = $CenterContainer/Panel/MarginContainer/VBoxContainer/SettingsContainer/CheckSound
@onready var check_autostop: CheckButton = $CenterContainer/Panel/MarginContainer/VBoxContainer/SettingsContainer/CheckAutostop
@onready var check_points: CheckButton = $CenterContainer/Panel/MarginContainer/VBoxContainer/SettingsContainer/CheckPoints
@onready var check_round: CheckButton = $CenterContainer/Panel/MarginContainer/VBoxContainer/SettingsContainer/CheckRound

var settings_changed: bool = false


func _sync_ui_with_settings() -> void:
	check_sound.set_pressed_no_signal(Settings.is_sound_enabled)
	check_autostop.set_pressed_no_signal(Settings.is_autostop_enabled)
	check_points.set_pressed_no_signal(Settings.is_points_visible)
	check_round.set_pressed_no_signal(Settings.is_round_enabled)


func open() -> void:
	_sync_ui_with_settings()
	show()


func _on_check_sound_toggled(toggled_on: bool) -> void:
	Settings.is_sound_enabled = toggled_on
	UserData.save_settings()
	settings_changed = true


func _on_check_autostop_toggled(toggled_on: bool) -> void:
	Settings.is_autostop_enabled = toggled_on
	UserData.save_settings()
	settings_changed = true


func _on_check_points_toggled(toggled_on: bool) -> void:
	Settings.is_points_visible = toggled_on
	UserData.save_settings()
	settings_changed = true

	# Okamžitá aktualizace viditelnosti score komponenty
	var score = get_tree().current_scene.get_node_or_null("Menu/HBoxContainer/HBoxContainerCenter")
	if score and score.has_method("update_visibility"):
		score.update_visibility()

	# Okamžité skrytí/zobrazení bodů u písmen
	var letter = get_tree().current_scene.get_node_or_null("MarginContainer/VBoxContainer/Letter")
	if letter:
		if toggled_on:
			if letter.has_method("points_show"):
				letter.points_show()
		else:
			if letter.has_method("points_hide"):
				letter.points_hide()


func _on_check_round_toggled(toggled_on: bool) -> void:
	Settings.is_round_enabled = toggled_on
	UserData.save_settings()
	settings_changed = true


func _input(event: InputEvent) -> void:
	if visible and event.is_action_pressed("ui_cancel"):
		_close()


func _on_button_score_reset_pressed() -> void:
	var score = get_tree().current_scene.get_node_or_null("Menu/HBoxContainer/HBoxContainerCenter")
	if score and score.has_method("reset_scores"):
		score.reset_scores()
		print("[ModalSettings] Skóre bylo vynulováno")


func _on_button_close_pressed() -> void:
	_close()


func _close() -> void:
	hide()
	get_tree().paused = false

	if settings_changed:
		settings_changed = false
		get_tree().reload_current_scene()
