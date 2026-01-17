extends MarginContainer

signal signal_open_settings
signal signal_play_pressed

@onready var button_play: Button = $HBoxContainer/Panel2/ButtonPlay


func set_play_button_text(is_active: bool) -> void:
	button_play.text = "Stop" if is_active else "Hrej"


func set_play_button_disabled(disabled: bool) -> void:
	button_play.disabled = disabled


func _on_button_settings_pressed() -> void:
	signal_open_settings.emit()


func _on_button_play_pressed() -> void:
	signal_play_pressed.emit()
