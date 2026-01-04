class_name Round
extends PanelContainer

signal round_finished

@onready var timer_round: Timer = $TimerRound
@onready var timer_round_step: Timer = $TimerRoundStep
@onready var progress_bar: ProgressBar = $MarginContainer/HBoxContainer/Panel/ProgressBar
@onready var label: Label = $MarginContainer/HBoxContainer/Label

var current_time: int = 0
var remaining_time: int = 0

func _ready() -> void:
	# Nastavení časovače
	timer_round.wait_time = Settings.round_wait_time
	
	# Nastavení textu pro zbývající čas	
	remaining_time = int(Settings.round_wait_time)
	label.text = str(remaining_time) + ' ' + tr("UI_SEC")

	self.hide()

# Začátek kola
func start() -> void:
	progress_bar.value = 0.0
	remaining_time = int(Settings.round_wait_time)
	label.text = str(remaining_time) + ' ' + tr("UI_SEC")
	
	self.show()
	timer_round.start()
	timer_round_step.start()

# Konec kola
func end() -> void:	
	self.hide()	
	timer_round.stop()
	timer_round_step.stop()
	round_finished.emit()

# Aktualizace progress baru podle zbývajícího času
func _process(_delta: float) -> void:	
	if not timer_round.is_stopped():
		progress_bar.value = (1.0 - (timer_round.time_left / timer_round.wait_time)) * 100		
	
# Spustí se když je kolo ukončeno
func _on_timer_round_timeout() -> void:
	end()

# Sekundový časovač pro odpočet kola - mění text v labelu u progress baru
func _on_timer_round_step_timeout() -> void:
	current_time += 1
	remaining_time -= 1
	
	label.text = str(remaining_time) + ' ' + tr("UI_SEC")
