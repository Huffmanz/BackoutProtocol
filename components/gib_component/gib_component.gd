class_name  GibComponent
extends Node2D

@onready var cpu_particles_2d: CPUParticles2D = $CPUParticles2D
@onready var timer: Timer = $Timer
@onready var random_stream_player: AudioStreamPlayer2D = $RandomStreamPlayer

func _ready() -> void:
	timer.timeout.connect(queue_free)
	cpu_particles_2d.emitting = true
	random_stream_player.play_random()
