extends CPUParticles2D

@onready var timer = $Timer

func _ready():
	timer.timeout.connect(on_timer_timeout)
	
func on_timer_timeout():
	set_process(false)
	set_physics_process(false)
	set_process_input(false)
	set_process_internal(false)
	set_process_unhandled_input(false)
	set_process_unhandled_key_input(false)
