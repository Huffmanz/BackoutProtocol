extends CharacterBody2D

@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var hurtbox_component : HurtboxComponent = $HurtboxComponent
@onready var health_component : HealthComponent = $HealthComponent
@onready var light_detector : LightDetector = $LightDetector
@onready var nav_agent : NavigationAgent2D = $NavigationAgent2D
@onready var velocity_component : VelocityComponent = $VelocityComponent
@onready var graphics : Node2D = $Graphics
@onready var crawl_audio : RandomStreamPlayer = $CrawlingAudioPlayer

var gib_component = preload("res://components/gib_component/gib_component.tscn")

var is_hurt = false
var in_light = false
var direction := Vector2.ZERO

func _ready():
	hurtbox_component.health_component = health_component
	hurtbox_component.hit.connect(on_hit)
	health_component.died.connect(on_died)
	light_detector.light_detected.connect(on_light_detected)
	nav_agent.velocity_computed.connect(on_velocity_computed)
	var mat = graphics.material
	if mat is CanvasItemMaterial:
		mat.light_mode = CanvasItemMaterial.LIGHT_MODE_LIGHT_ONLY


func _process(_delta):
	if is_hurt:
		return
	var current_location = global_position
	nav_agent.target_position = Utils.get_player().global_position
	var  next_location = Vector2.ZERO
	if nav_agent.is_target_reachable() and !in_light:
		next_location = nav_agent.get_next_path_position()
		direction = (next_location - current_location).normalized()
		nav_agent.set_velocity(velocity_component.accelerate_in_direction(direction))
		animation_player.play("crawl")
		look_at(Utils.get_player().global_position)	
	else:
		animation_player.play("idle")

	if in_light:
		nav_agent.set_velocity(Vector2.ZERO)
		animation_player.play("idle")

	if velocity.length() > 0:
		if !crawl_audio.playing:
			crawl_audio.play_random()
	else:	
		crawl_audio.stop()
	move_and_slide()

func on_velocity_computed(safe_velocity):
	velocity = safe_velocity
	move_and_slide()

func on_light_detected(light_detected: bool):
	in_light = light_detected
	
func on_hit():
	is_hurt = true
	animation_player.play("hurt")
	await animation_player.animation_finished
	is_hurt = false
	
func on_died():
	var gib_instance = gib_component.instantiate() as GibComponent
	gib_instance.global_position = global_position
	get_tree().current_scene.add_child(gib_instance)
	queue_free()
