extends PanelContainer

@onready var timer_spin: Timer = $TimerSpin
@onready var timer_autostop: Timer = $TimerAutostop
@onready var background: Panel = $Background
@onready var letter: Letter = $MarginContainer/VBoxContainer/Letter
@onready var subject: Subject = $MarginContainer/VBoxContainer/Subject
@onready var answer: PanelContainer = $MarginContainer/VBoxContainer/Answer

# --- Stav aplikace ---

var is_spinning: bool = false
var is_stopping: bool = false

var current_letter: String = ""
var current_subject: String = ""
var current_answer: String = ""
var current_points: int = 0

func _ready() -> void:
	randomize()
	
	# Generovana barva pozadi
	Visuals.change_background_color(background)
	
	# Nastavení rychlosti časovačů
	timer_spin.wait_time = Settings.spin_wait_time
	timer_autostop.wait_time = Settings.autostop_wait_time
	
	# Pokud chceš, aby to začalo hned (autostart)
	spin_start()

# ========================
# Logika losování
# ========================

func spin_start() -> void:
	print("[Spin] Začátek losování")
	is_spinning = true
	is_stopping = false
	
	# Resetujeme rychlost timeru na výchozí hodnotu
	timer_spin.wait_time = Settings.spin_wait_time
	
	timer_spin.start()
	timer_autostop.start()	

func spin_stop() -> void:
	print("[Spin] Začíná zpomalování")
	is_spinning = false
	is_stopping = true

func spin_finalize() -> void:
	is_stopping = false
	timer_spin.stop()
	timer_autostop.stop()
		
	current_letter = letter.get_current_letter()
	current_subject = subject.get_current_subject()		
	current_answer = answer.get_answer(current_subject, current_letter)	
	current_points = letter.get_current_points()
	
	Visuals.screen_shake(self, 6.0, 0.3)
	Visuals.pop_animation(subject, 1.6)	
	
	# answer.show_answer(current_subject, current_letter)	

	print("[Spin] Konec losování")
	print("[Game] Písmeno: ", current_letter)
	print("[Game] Slovo: ", current_subject)	
	print("[Game] Odpověď: ", current_answer)
	print("[Game] Body: ", current_points)	

# ========================
# Signály časovače
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
	if is_spinning:
		print("[Spin] Aktivován autostop")
		spin_stop()
