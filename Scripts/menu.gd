extends MarginContainer

signal signal_open_settings
signal signal_play_pressed
signal signal_help_pressed

@onready var button_play: TextureButton = $HBoxContainer/Panel2/ButtonPlay
@onready var button_help: TextureButton = $HBoxContainer/Panel2/ButtonHelp
@onready var button_settings: TextureButton = $HBoxContainer/Panel/ButtonSettings

var texture_play: Texture2D = preload("res://Assets/Icons/play.svg")
var texture_pause: Texture2D = preload("res://Assets/Icons/pause.svg")


func _ready() -> void:
	button_settings.mouse_entered.connect(_on_button_settings_mouse_entered)
	button_settings.mouse_exited.connect(_on_button_settings_mouse_exited)
	button_play.mouse_entered.connect(_on_button_play_mouse_entered)
	button_play.mouse_exited.connect(_on_button_play_mouse_exited)
	button_help.mouse_entered.connect(_on_button_help_mouse_entered)
	button_help.mouse_exited.connect(_on_button_help_mouse_exited)


func _on_button_settings_mouse_entered() -> void:
	button_settings.modulate.a = 1.0


func _on_button_settings_mouse_exited() -> void:
	button_settings.modulate.a = 0.5


func _on_button_play_mouse_entered() -> void:
	if not button_play.disabled:
		button_play.modulate.a = 1.0


func _on_button_play_mouse_exited() -> void:
	if not button_play.disabled:
		button_play.modulate.a = 0.5


func _on_button_help_mouse_entered() -> void:
	button_help.modulate.a = 1.0


func _on_button_help_mouse_exited() -> void:
	button_help.modulate.a = 0.5


func set_play_button_text(is_active: bool) -> void:
	button_play.texture_normal = texture_pause if is_active else texture_play


func set_play_button_disabled(disabled: bool) -> void:
	button_play.disabled = disabled
	button_play.modulate.a = 0.1 if disabled else 0.5
	button_play.mouse_default_cursor_shape = Control.CURSOR_FORBIDDEN if disabled else Control.CURSOR_POINTING_HAND


func show_help_button() -> void:
	button_help.visible = true


func hide_help_button() -> void:
	button_help.visible = false


func _on_button_settings_pressed() -> void:
	signal_open_settings.emit()


func _on_button_play_pressed() -> void:
	signal_play_pressed.emit()


func _on_button_help_pressed() -> void:
	signal_help_pressed.emit()
