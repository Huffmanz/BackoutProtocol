class_name Player
extends CharacterBody2D


@export var speed = 150.0
@export var shotgun : Node2D
@export var bullet : PackedScene = preload("res://player/bullet.tscn")
@export var muzzle : Marker2D
@export var time_between_shots : float = 0.5
@export var max_battery_charge : float = 100.0
#light
@export var light_intensity: float = 1.0
@export var zoom_step: float = 0.1
@export var min_zoom: float = 0.5
@export var max_zoom: float = 3.0
@export var battery_drain_rate: float = 5.0

@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var legs : AnimatedSprite2D = $Graphics/Legs
@onready var shotgun_fire_audio : RandomStreamPlayer = $ShotgunFire
@onready var footstep_audio : RandomStreamPlayer = $FootstepSound
@onready var upper_body : Node2D = $Graphics/UpperBody
@onready var hurtbox_component: HurtboxComponent = $HurtboxComponent
@onready var health_component: HealthComponent = $HealthComponent
@onready var hurt_audio: RandomStreamPlayer = $HurtAudioPlayer
@onready var lights: Node2D = %Lights
@onready var flashlight: PointLight2D = %Flashlight

var current_battery_charge : float = 0.0

var is_aiming = false
var is_shooting = false

func _ready():
	health_component.health_decreased.connect(on_health_decreased)
	current_battery_charge = max_battery_charge
	GameEvents.battery_charge_updated.emit(current_battery_charge, max_battery_charge)
	flashlight.energy = light_intensity

func on_health_decreased(amount: float):
	print("Player health decreased: ", amount)
	GameEvents.player_health_updated.emit(health_component.current_health, health_component.max_health)
	hurt_audio.play_random()


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		match event.button_index:
			MOUSE_BUTTON_WHEEL_UP:
				lights.scale.x -= zoom_step
			MOUSE_BUTTON_WHEEL_DOWN:
				lights.scale.x += zoom_step

		lights.scale.x = clamp(lights.scale.x, min_zoom, max_zoom)
		print(lights.scale.x)

func get_movement_vector():
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vector.y = Input.get_action_strength("move_back") - Input.get_action_strength("move_up")
	return input_vector.normalized()
 
func _process(delta):
	#get movement vector
	var battery_ratio = lights.scale.x / max_zoom
	current_battery_charge -= clamp(delta * battery_ratio * battery_drain_rate, 0, current_battery_charge)
	var current_light_energy = light_intensity * (current_battery_charge / max_battery_charge)
	flashlight.energy = clamp(current_light_energy, 0, light_intensity)
	print(flashlight.energy)
	if current_battery_charge > 0:
		GameEvents.battery_charge_updated.emit(current_battery_charge, max_battery_charge)
	else:
		lights.visible = false
		GameEvents.battery_depleted.emit()
	if is_shooting:
		await animation_player.animation_finished
		is_shooting = false
		return
	var movement_direction = get_movement_vector()
	# Rotate legs based on input where mouse direction is "forward"
	var forward = (get_global_mouse_position() - global_position).normalized()
	var right = Vector2(forward.y, -forward.x) # perpendicular (clockwise 90°) to forward
	# Map input (x=strape, y=back/forward) to world using forward as -y
	var local_input = Vector2(movement_direction.x, -movement_direction.y)

	var leg_world_dir = right * local_input.x + forward * local_input.y
	# Fix case where mouse is left/right (predominantly horizontal): adjust by ±90° only then
	if abs(forward.x) > abs(forward.y):
		leg_world_dir = leg_world_dir.rotated(-sign(forward.x) * PI/2.0)
	if leg_world_dir != Vector2.ZERO:
		legs.rotation = leg_world_dir.angle()

	var upper_body_rotation = (upper_body.global_position - get_global_mouse_position()).angle() + PI
	upper_body.rotation = upper_body_rotation
	if movement_direction != Vector2.ZERO:
		if velocity.length() == 0:
			legs.play("walk")
			animation_player.play("walk")
		velocity = movement_direction * speed   
	else:
		velocity = Vector2.ZERO
		legs.stop()
		legs.frame = 2

	if legs.frame == 0 or legs.frame == 4:
		footstep_audio.play_random()



	if Input.is_action_just_pressed("fire") and movement_direction == Vector2.ZERO and !is_shooting:
		shoot_projectile()
		animation_player.play("fire")
		is_shooting = true
		GameEvents.emit_camera_shake(20)
		await get_tree().create_timer(time_between_shots).timeout
	elif movement_direction == Vector2.ZERO:
		animation_player.play("aim")
	move_and_slide()

func shoot_projectile():
	var bullet_instance: CharacterBody2D = bullet.instantiate()
	bullet_instance.global_position = muzzle.global_position
	bullet_instance.rotation_degrees = muzzle.global_rotation_degrees + 178
	get_tree().current_scene.add_child(bullet_instance)
	shotgun_fire_audio.play_random()
