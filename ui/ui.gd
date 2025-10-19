extends CanvasLayer

@onready var battery_bar: ProgressBar = %BatteryBar
@onready var static_rect : ColorRect = $StaticRect
@onready var vignette_rect : ColorRect = $VignetteRect

func _ready():
	GameEvents.battery_charge_updated.connect(on_battery_charge_updated)
	GameEvents.battery_depleted.connect(on_battery_depleted)
	GameEvents.player_health_updated.connect(on_player_health_updated)

func on_battery_charge_updated(current_battery_charge: float, max_battery_charge: float):
	battery_bar.value = current_battery_charge / max_battery_charge

func on_battery_depleted():
	battery_bar.value = 0

func on_player_health_updated(current_health: float, max_health: float):
	var health_percent = current_health / max_health
	#static_rect.material.set_shader_parameter("Transparency", 2.0 * (current_health / max_health))
	vignette_rect.material.set_shader_parameter("vignette_intensity", 0.4 + (current_health / max_health))