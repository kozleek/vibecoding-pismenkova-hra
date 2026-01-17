class_name Game
extends PanelContainer

signal signal_spin_start
signal signal_spin_stop
signal signal_spin_finalize

@onready var timer_spin: Timer = $TimerSpin
@onready var timer_autostop: Timer = $TimerAutostop
@onready var background: Panel = $Background
@onready var letter: Letter = $MarginContainer/VBoxContainer/Letter
@onready var subject: Subject = $MarginContainer/VBoxContainer/Subject
@onready var answer: PanelContainer = $MarginContainer/VBoxContainer/Answer
@onready var round: Round = $Round
@onready var modal_settings: PanelContainer = $ModalSettings
@onready var menu: MarginContainer = $Menu
@onready var score: Score = $Menu/HBoxContainer/HBoxContainerCenter

# --- Stav aplikace ---

var is_spinning: bool = false # je aktivní proces losování?
var is_stopping: bool = false # je spuštěno zpomalení losování?
var is_finalize: bool = false # je kompletně zastavený proces losování?
var is_round_active: bool = false # je aktivní odpočet kola?
var is_round_finished: bool = false # je kolo dokončeno a čeká se na další kolo?

var current_letter: String = ""
var current_subject: String = ""
var current_answer: String = ""
var current_points: int = 0

func _ready() -> void:
	randomize()

	# Aplikace zvukových nastavení (data jsou již načtena v UserData autoloadu)
	Audio.apply_sound_settings()

	# Generovana barva pozadi
	Visuals.change_background_color(background)

	# Nastavení rychlosti časovačů
	timer_spin.wait_time = Settings.spin_wait_time
	timer_autostop.wait_time = Settings.autostop_wait_time

	# Spuštění losování
	spin_start()

# ========================
# Logika losování
# ========================

func spin_start() -> void:
	print("[Game] Začátek losování")
	signal_spin_start.emit()
	is_spinning = true
	is_stopping = false
	is_finalize = false
	is_round_active = false

	# Aktualizace UI
	menu.set_play_button_text(true)
	menu.set_play_button_disabled(false)
	menu.hide_help_button()

	# Ukončení herního kola a skrytí odpovědi
	answer.hide()
	round.end()
	#letter.points_hide()

	# Zakázat přičítání bodů během losování
	score.disable_scoring()

	# Resetujeme rychlost timeru na výchozí hodnotu
	timer_spin.wait_time = Settings.spin_wait_time

	timer_spin.start()
	if Settings.is_autostop_enabled:
		timer_autostop.start()

func spin_stop() -> void:
	print("[Game] Začíná zpomalování")
	signal_spin_stop.emit()
	is_spinning = false
	is_stopping = true
	is_finalize = false

	# Aktualizace UI
	menu.set_play_button_disabled(true)

func spin_finalize() -> void:
	print("[Game] Konec losování")
	signal_spin_finalize.emit()
	is_spinning = false
	is_stopping = false
	is_finalize = true

	# Aktualizace UI
	menu.set_play_button_text(false)
	menu.set_play_button_disabled(Settings.is_round_enabled)

	# Pro jistotu zastavíme všechny časovače
	timer_spin.stop()
	timer_autostop.stop()

	current_letter = letter.get_current_letter()
	current_subject = subject.get_current_subject()
	current_answer = answer.get_answer(current_subject, current_letter)
	current_points = letter.get_current_points()

	print("[Game] --- Písmeno: ", current_letter)
	print("[Game] --- Slovo: ", current_subject)
	print("[Game] --- Odpověď: ", current_answer)
	print("[Game] --- Body: ", current_points)

	Visuals.screen_shake(self, 6.0, 0.3)
	Visuals.pop_animation(subject, 1.6)

	#letter.points_show()

	# Zobrazíme tlačítko Help pokud není povoleno kolo
	if not Settings.is_round_enabled:
		menu.show_help_button()
		# Pokud není povoleno kolo, umožníme přičítání bodů ihned
		score.enable_scoring(current_points)

	# Spustíme odpočet kola
	round_start()	

# ========================
# Logika herních kol
# ========================

func round_start() -> void:
	if Settings.is_round_enabled:
		print("[Round] Start kola")
		is_round_active = true
		is_round_finished = false
		round.start()

func round_end() -> void:
	if Settings.is_round_enabled and is_round_active:
		print("[Round] Konec kola")
		is_round_active = false
		is_round_finished = true
		menu.set_play_button_disabled(false)
		menu.show_help_button()
		# Po skončení kola umožníme přičítání bodů
		score.enable_scoring(current_points)	

# ========================
# Signály
# ========================

# Časovač losování
func _on_timer_spin_timeout() -> void:
	# 1. VŽDY nejdříve pohneme písmenem a slovem
	letter.draw_letter()
	subject.draw_subject()	
	
	# 2. Pokud zpomalujeme, upravíme čas a zkontrolujeme zastavení
	if is_stopping:
		timer_spin.wait_time = timer_spin.wait_time * Settings.slowdown_factor
		
		# Pokud je interval už příliš dlouhý, zastavíme úplně
		if timer_spin.wait_time >= Settings.slowdown_stop_speed:
			spin_finalize()

# Časovač pro automatické zastavení
func _on_timer_autostop_timeout() -> void:
	if Settings.is_autostop_enabled and is_spinning:
		print("[Game] Aktivován autostop: ", timer_autostop.wait_time)
		spin_stop()

# Časovač konce kola
func _on_round_signal_round_finished() -> void:
	round_end()

# Otevření nastavení
func _on_menu_signal_open_settings() -> void:
	modal_settings.open()
	get_tree().paused = true


# Tlačítko Help
func _on_menu_signal_help_pressed() -> void:
	if (is_round_finished and is_finalize) or (not Settings.is_round_enabled and is_finalize):	
		print("[Menu:Help] Zobrazení odpovědi (tlačítko)")
		answer.show_answer(current_subject, current_letter)
		menu.hide_help_button()
	else:
		print("[Menu:Help] Odpověď nelze zobrazit. is_round_enabled: %s, is_round_finished: %s, is_finalize: %s" % [Settings.is_round_enabled, is_round_finished, is_finalize])


# Tlačítko Play/Stop
func _on_menu_signal_play_pressed() -> void:
	if is_spinning:
		spin_stop()
	elif is_finalize and (is_round_finished or not Settings.is_round_enabled):
		spin_start()
