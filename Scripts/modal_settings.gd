extends PanelContainer

# Odkazy na checkboxy v nastavení
@onready var check_sound: CheckButton = $CenterContainer/Panel/MarginContainer/VBoxContainer/SettingsContainer/CheckSound
@onready var check_autostop: CheckButton = $CenterContainer/Panel/MarginContainer/VBoxContainer/SettingsContainer/CheckAutostop
@onready var check_points: CheckButton = $CenterContainer/Panel/MarginContainer/VBoxContainer/SettingsContainer/CheckPoints
@onready var check_round: CheckButton = $CenterContainer/Panel/MarginContainer/VBoxContainer/SettingsContainer/CheckRound
@onready var check_no_repeat: CheckButton = $CenterContainer/Panel/MarginContainer/VBoxContainer/SettingsContainer/CheckNoRepeat
@onready var round_time_container: HBoxContainer = $CenterContainer/Panel/MarginContainer/VBoxContainer/SettingsContainer/MarginContainer/RoundTimeContainer
@onready var round_time_label: Label = $CenterContainer/Panel/MarginContainer/VBoxContainer/SettingsContainer/MarginContainer/RoundTimeContainer/RoundTimeLabel
@onready var round_time: LineEdit = $CenterContainer/Panel/MarginContainer/VBoxContainer/SettingsContainer/MarginContainer/RoundTimeContainer/RoundTime

# Odkazy na tlačítka pro výběr jazyka
@onready var button_language_cs: Button = $CenterContainer/Panel/MarginContainer/VBoxContainer/LanguageContainer/ButtonLanguageCS
@onready var button_language_en: Button = $CenterContainer/Panel/MarginContainer/VBoxContainer/LanguageContainer/ButtonLanguageEN
@onready var button_language_fr: Button = $CenterContainer/Panel/MarginContainer/VBoxContainer/LanguageContainer/ButtonLanguageFR
@onready var button_language_es: Button = $CenterContainer/Panel/MarginContainer/VBoxContainer/LanguageContainer/ButtonLanguageES

# Odkazy na ostatní tlačítka
@onready var button_score_reset: Button = $CenterContainer/Panel/MarginContainer/VBoxContainer/ButtonScoreReset
@onready var button_close: Button = $CenterContainer/Panel/MarginContainer/VBoxContainer/ButtonClose

# Flag indikující, zda došlo ke změně nastavení (při zavření dialogu se reloadne scéna)
var settings_changed: bool = false

func _ready() -> void:
	# Připojení k signálu změny jazyka pro okamžitou aktualizaci UI
	Settings.language_changed.connect(_on_language_changed)

	# Inicializace UI textů
	_refresh_ui_texts()

# Aktualizuje všechny lokalizované texty v UI
# Volá se při startu a při změně jazyka
func _refresh_ui_texts() -> void:
	# Nastavení lokalizovaných textů pro checkboxy
	# Používá translation keys z translations.csv s prefixem UI_SETTINGS_
	check_sound.text = tr("UI_SETTINGS_SOUND")
	check_autostop.text = tr("UI_SETTINGS_AUTOSTOP")
	check_points.text = tr("UI_SETTINGS_POINTS")
	check_round.text = tr("UI_SETTINGS_ROUND")
	check_no_repeat.text = tr("UI_SETTINGS_NO_REPEAT")
	round_time_label.text = tr("UI_SETTINGS_ROUND_TIME")

	# Nastavení textu jazykových tlačítek
	button_language_cs.text = tr("UI_LANG_CZECH")
	button_language_en.text = tr("UI_LANG_ENGLISH")
	button_language_fr.text = tr("UI_LANG_FRENCH")
	button_language_es.text = tr("UI_LANG_SPANISH")

	# Zvýraznění aktivního jazyka
	_update_language_buttons()

	# Nastavení lokalizovaných textů pro tlačítka
	button_score_reset.text = tr("UI_SETTINGS_RESET_SCORE")
	button_close.text = tr("UI_SETTINGS_CLOSE")

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

	# Nastavení hodnoty časového limitu kola
	round_time.text = str(Settings.round_time)

	# Zobrazení/skrytí nastavení času kola podle stavu check_round
	round_time_container.visible = Settings.is_round_enabled

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
# Také zobrazí/skryje nastavení času kola
func _on_check_round_toggled(toggled_on: bool) -> void:
	Settings.is_round_enabled = toggled_on
	_save_setting_change()

	# Zobrazení/skrytí nastavení času kola
	round_time_container.visible = toggled_on

# Callback pro změnu herního módu "Bez opakování"
func _on_check_no_repeat_toggled(toggled_on: bool) -> void:
	Settings.is_no_repeat_enabled = toggled_on
	_save_setting_change()

# Helper funkce pro validaci a uložení času kola
# Validuje vstup a ukládá pouze platné celé číselné hodnoty (int)
func _validate_and_save_round_time() -> void:
	# Validace vstupu - převod na int
	var time_value = round_time.text.to_int()

	# Kontrola rozumného rozsahu (1-999 sekund)
	if time_value < 1:
		time_value = 1
		push_warning("[ModalSettings] Minimální čas kola je 1 sekunda")
	elif time_value > 999:
		time_value = 999
		push_warning("[ModalSettings] Maximální čas kola je 999 sekund")

	# Pokud se hodnota změnila, uložíme ji
	if Settings.round_time != time_value:
		Settings.round_time = time_value
		round_time.text = str(time_value)
		_save_setting_change()
		print("[ModalSettings] Čas kola změněn na: %d sekund" % time_value)

# ========================
# Callback funkce pro jazykové tlačítka
# ========================

# Callback pro tlačítko CS - přepne na češtinu
func _on_button_language_cs_pressed() -> void:
	Settings.change_language("cs")
	_save_setting_change()

# Callback pro tlačítko EN - přepne na angličtinu
func _on_button_language_en_pressed() -> void:
	Settings.change_language("en")
	_save_setting_change()

# Callback pro tlačítko Fr - přepne na francouštinu
func _on_button_language_fr_pressed() -> void:
	Settings.change_language("fr")
	_save_setting_change()

# Callback pro tlačítko ES - přepne na španělštinu
func _on_button_language_es_pressed() -> void:
	Settings.change_language("es")
	_save_setting_change()

# Callback pro signál změny jazyka - okamžitě refreshne UI
func _on_language_changed(_language_code: String) -> void:
	_refresh_ui_texts()

# Aktualizuje vizuální stav jazykových tlačítek
# Aktuálně vybraný jazyk je disabled, ostatní enabled
# Dynamické řešení - funguje pro libovolný počet jazyků
func _update_language_buttons() -> void:
	# Dictionary mapující tlačítka na kódy jazyků
	var language_buttons = {
		button_language_cs: "cs",
		button_language_en: "en",
		button_language_fr: "fr",
		button_language_es: "es"
	}

	# Iterace přes všechna jazyková tlačítka
	for button in language_buttons:
		var lang_code = language_buttons[button]

		if lang_code == Settings.current_language:
			# Aktuální jazyk - disabled, nelze kliknout
			button.disabled = true
			button.mouse_default_cursor_shape = Control.CURSOR_FORBIDDEN
		else:
			# Ostatní jazyky - enabled, lze kliknout
			button.disabled = false
			button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
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
	# Před zavřením validujeme a uložíme čas kola
	_validate_and_save_round_time()

	hide()
	get_tree().paused = false

	# Pokud došlo ke změnám, je potřeba reload scény (kvůli aktualizaci UI)
	if settings_changed:
		settings_changed = false
		get_tree().reload_current_scene()
