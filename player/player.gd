class_name Player
extends CharacterBody2D


@export var speed = 150.0
@export var shotgun : Node2D
@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var legs : AnimatedSprite2D = $Graphics/Legs


var is_aiming = false
var is_shooting = false

func get_movement_vector():
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vector.y = Input.get_action_strength("move_back") - Input.get_action_strength("move_up")
	return input_vector
 
func _process(delta):
	#get movement vector
	var movement_direction = get_movement_vector()
	#move player
	look_at(get_global_mouse_position())
	if movement_direction != Vector2.ZERO and !is_shooting:
		velocity = movement_direction * speed   
		animation_player.play("walk")
		legs.play("walk")
	else:
		velocity = Vector2.ZERO
		legs.stop()
		legs.frame = 2

	if Input.is_action_just_pressed("fire") and movement_direction == Vector2.ZERO:
		animation_player.play("fire")
		is_shooting = true
		GameEvents.emit_camera_shake(10)
		await get_tree().create_timer(0.5).timeout
		is_shooting = false
	else:
		if !is_shooting and movement_direction == Vector2.ZERO:
			animation_player.play("aim")
	print(animation_player.current_animation)
	move_and_slide()
