extends Node

func _ready() -> void:
	# Načíst nastavení při inicializaci (autoload se inicializuje před scénami)
	load_settings()

# ========================
# Uložení nastavení
# ========================

func save_settings() -> void:
	var settings_data = {
		"is_sound_enabled": Settings.is_sound_enabled,
		"is_mic_enabled": Settings.is_mic_enabled,
		"is_autostop_enabled": Settings.is_autostop_enabled,
		# Vector2i nelze přímo uložit do JSON, musíme ho rozložit
		"points_min": Settings.points_range.x,
		"points_max": Settings.points_range.y,
		"is_points_visible": Settings.is_points_visible,
		"is_round_enabled": Settings.is_round_enabled,
		"is_no_repeat_enabled": Settings.is_no_repeat_enabled,
		"team1_score": Settings.team1_score,
		"team2_score": Settings.team2_score
	}
	
	var file = FileAccess.open(Settings.SAVEDATA_PATH, FileAccess.WRITE)
	if file:
		var json_string = JSON.stringify(settings_data, "\t")
		file.store_string(json_string)
		file.close()
		print("[UserData] Nastavení bylo uloženo do: ", Settings.SAVEDATA_PATH)

# ========================
# Načtení nastavení
# ========================

func load_settings() -> void:
	if not FileAccess.file_exists(Settings.SAVEDATA_PATH):
		print("[UserData] Žádný ukládací soubor nenalezen, používám výchozí hodnoty.")
		return

	var file = FileAccess.open(Settings.SAVEDATA_PATH, FileAccess.READ)
	if file:
		var json_text = file.get_as_text()
		file.close()
		
		var json = JSON.new()
		var error = json.parse(json_text)
		
		if error == OK:
			var data = json.data
			# Načítáme hodnoty a používáme get() s výchozí hodnotou pro bezpečnost
			Settings.is_sound_enabled = data.get("is_sound_enabled", Settings.is_sound_enabled)
			Settings.is_mic_enabled = data.get("is_mic_enabled", Settings.is_mic_enabled)
			Settings.is_autostop_enabled = data.get("is_autostop_enabled", Settings.is_autostop_enabled)
			Settings.is_points_visible = data.get("is_points_visible", Settings.is_points_visible)
			Settings.is_round_enabled = data.get("is_round_enabled", Settings.is_round_enabled)
			Settings.is_no_repeat_enabled = data.get("is_no_repeat_enabled", Settings.is_no_repeat_enabled)
			Settings.team1_score = data.get("team1_score", Settings.team1_score)
			Settings.team2_score = data.get("team2_score", Settings.team2_score)

			# Rekonstrukce Vector2i
			if data.has("points_min") and data.has("points_max"):
				Settings.points_range = Vector2i(data["points_min"], data["points_max"])

			print("[UserData] Nastavení bylo úspěšně načteno.")
			print("[UserData] --- is_sound_enabled: ", Settings.is_sound_enabled)
			print("[UserData] --- is_autostop_enabled: ", Settings.is_autostop_enabled)
			print("[UserData] --- is_points_visible: ", Settings.is_points_visible)
			print("[UserData] --- is_round_enabled: ", Settings.is_round_enabled)
			print("[UserData] --- is_no_repeat_enabled: ", Settings.is_no_repeat_enabled)
			print("[UserData] --- points_range: ", Settings.points_range)
			print("[UserData] --- team1_score: ", Settings.team1_score)
			print("[UserData] --- team2_score: ", Settings.team2_score)
		else:
			print("[UserData] Chyba při čtení JSONu: ", json.get_error_message())
