extends Node

#player
signal camera_shake(camera_shake_strength: float)
signal player_health_updated(current_health: float, max_health: float)
signal player_died()
signal battery_charge_updated(current_battery_charge: float, max_battery_charge: float)
signal battery_depleted()
#wave management
signal wave_started(wave_number: int)
signal wave_complete(wave_number: int)
signal wave_start_next()

func emit_camera_shake(camera_shake_strength: float) -> void:
	camera_shake.emit(camera_shake_strength)
	
func emit_player_health_updated(amount: float):
	player_health_updated.emit(amount)

func frameFreeze(timeScale, duration):
	Engine.time_scale = timeScale
	await get_tree().create_timer(duration * timeScale).timeout
	Engine.time_scale = 1.0
	