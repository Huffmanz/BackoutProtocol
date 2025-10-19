extends CPUParticles2D

@onready var timer = $Timer

func _ready():
	timer.timeout.connect(on_timer_timeout)
	emitting = true

func _physics_process(delta):
	if emitting:
		return
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0, 2.5)
	await tween.finished
	queue_free()

func on_timer_timeout():
	set_process(false)
	set_process_input(false)
	set_process_internal(false)
	set_process_unhandled_input(false)
	set_process_unhandled_key_input(false)
	emitting = false
