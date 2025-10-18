class_name Bullet
extends CharacterBody2D

@onready var hitbox_component: HitboxComponent = $HitboxComponent
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var velocity_component: VelocityComponent = $VelocityComponent
@onready var impact_effect: PackedScene = preload("res://addons/vfx/bullet_impact.tscn")


func _ready():
	hitbox_component.area_entered.connect(on_area_entered)
	hitbox_component.body_entered.connect(on_body_entered)
	

func _physics_process(delta):
	velocity = velocity_component.accelerate_in_direction(global_transform.x)
	move_and_slide()
	
func on_area_entered(other_area:Node2D):
	if not other_area is HurtboxComponent:
		return 
	set_physics_process(false)
	sprite_2d.visible = false
	queue_free()
	
func on_body_entered(other_body):
	var new_impact = impact_effect.instantiate()
	new_impact.global_position = global_position
	new_impact.rotation = global_position.angle_to_point(Utils.get_player().global_position)
	get_tree().current_scene.add_child(new_impact)
	queue_free() 



