class_name Round
extends PanelContainer

# Signál vyslaný po skončení kola (časovač doběhl)
signal signal_round_finished

# Odkazy na node strukture
@onready var game: Game = $".."
@onready var sound_effect: AudioStreamPlayer2D = $SoundEffect
@onready var sound_end: AudioStreamPlayer2D = $SoundEnd
@onready var timer_round: Timer = $TimerRound
@onready var timer_round_step: Timer = $TimerRoundStep

# Odkazy na UI prvky
@onready var progress_bar: ProgressBar = $MarginContainer/HBoxContainer/Panel/ProgressBar
@onready var label: Label = $MarginContainer/HBoxContainer/Label

# Zbývající čas v sekundách (odpočítává se každou sekundu)
var remaining_time: int = 0

func _ready() -> void:
	# Validace nastavení - round_time by měla být kladná
	if Settings.round_time <= 0:
		push_warning("Round wait time is invalid: %s. Using default 30s." % Settings.round_time)
		timer_round.wait_time = 30.0
	else:
		# Nastavení délky kola z globálního nastavení
		timer_round.wait_time = Settings.round_time

	# Inicializace zbývajícího času a UI
	remaining_time = int(timer_round.wait_time)
	label.text = str(remaining_time) + ' ' + tr("UI_SEC")

	# Skrýt panel kola při startu (zobrazí se až při start())
	self.hide()

# ========================
# Ovládání herních kol
# ========================

# Spustí kolo s odpočtem času (volá se po finalizaci otáčení)
# Zobrazí progress bar a spustí časovače pokud jsou kola v nastavení povolena
func start() -> void:
	if not Settings.is_round_enabled:
		return

	# Reset progress baru na začátek
	progress_bar.value = 0.0

	# Reset zbývajícího času podle aktuálního nastavení
	remaining_time = int(Settings.round_time)
	label.text = str(remaining_time) + ' ' + tr("UI_SEC")

	# Zobrazení panelu a spuštění časovačů
	self.show()
	timer_round.start()
	timer_round_step.start()

# Ukončí kolo předčasně (volá se při startu nového otáčení)
# Skryje UI, zastaví časovače a vyšle signál o ukončení
func end() -> void:
	if not Settings.is_round_enabled:
		return

	# Skrytí panelu a zastavení časovačů
	self.hide()
	timer_round.stop()
	timer_round_step.stop()

	# Notifikace game controlleru o ukončení kola
	signal_round_finished.emit()	

# ========================
# Zobrazení stavu
# ========================

# Aktualizace progress baru každý frame podle zbývajícího času
# Vypočítává procentuální hodnotu z time_left časovače
func _process(_delta: float) -> void:
	if not timer_round.is_stopped() and timer_round.wait_time > 0:
		# Výpočet: (uběhlý čas / celkový čas) * 100 = procenta
		var elapsed_ratio = 1.0 - (timer_round.time_left / timer_round.wait_time)
		progress_bar.value = elapsed_ratio * 100.0		
	
# ========================
# Signály časovačů
# ========================

# Callback pro timeout hlavního časovače kola
# Vyvolá se když kolo doběhne (po Settings.round_wait_time sekundách)
func _on_timer_round_timeout() -> void:
	# Přehrání zvuku konce kola
	sound_end.play()

	# Vizuální efekt - třesení obrazovky
	Visuals.screen_shake(game, 20.0, 0.2)

	# Ukončení kola (skryje UI, vyšle signál)
	self.end()

# Callback pro sekundový časovač - tikání kola
# Vyvolá se každou sekundu během běhu kola
func _on_timer_round_step_timeout() -> void:
	# Přehrání tikacího zvuku
	sound_effect.play()

	# Snížení zbývajícího času a aktualizace labelu
	remaining_time -= 1

	# Ochrana proti záporným hodnotám (failsafe)
	if remaining_time < 0:
		remaining_time = 0

	label.text = str(remaining_time) + ' ' + tr("UI_SEC")
