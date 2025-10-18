class_name Gib
extends Sprite2D

@onready var bounce_component: BounceComponent = $BounceComponent
@onready var particle_timer: Timer = $CPUParticles2D/ParticleTimer
@onready var cpu_particles_2d: CPUParticles2D = $CPUParticles2D

var direction = Vector2.ZERO

func _ready() -> void:
	bounce_component.drop_height = randf_range(50,100)
	bounce_component.start()
	bounce_component.tween_completed.connect(on_tween_complete)
	direction.x = randf_range(-1.0, 1.0)
	direction.y = randf_range(-1.0, 1.0)
	print(direction)
	particle_timer.timeout.connect(cpu_particles_2d.queue_free)

func _physics_process(delta):
	return
	#if direction != Vector2.ZERO:
		#global_position += direction * delta * 300

func on_tween_complete():
	queue_free()
	direction = Vector2.ZERO
