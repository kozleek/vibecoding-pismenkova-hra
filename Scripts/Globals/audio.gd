extends Node


func apply_sound_settings() -> void:
	AudioServer.set_bus_mute(Settings.MASTER_BUS_INDEX, not Settings.is_sound_enabled)
	print("[Audio] Zvuk %s" % ("zapnut" if Settings.is_sound_enabled else "vypnut"))
