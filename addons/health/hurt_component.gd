extends Area2D
class_name HurtboxComponent

signal hit

@export var health_component: HealthComponent
@export var multiplier : float = 1
@export var show_damange_numbers : bool = true
@export var show_blood : bool = true
@export var blood_scene : PackedScene = preload("res://addons/vfx/blood.tscn")
var floating_text_scene = preload("res://addons/ui/floating_text.tscn")

func _ready():
	area_entered.connect(on_area_entered)
	
func on_area_entered(other_area:Area2D):
	if not other_area is HitboxComponent:
		return
		
	if health_component == null:
		return
		
	var hitbox_component = other_area as HitboxComponent
	var damage = ceil(hitbox_component.damage * multiplier)
	health_component.damage(damage)

	if show_damange_numbers:
		Utils.create_negative_numbers(global_position + (Vector2.UP * 16), damage)
	if show_blood:
		var new_blood = blood_scene.instantiate()
		new_blood.global_position = global_position	
		new_blood.rotation = Utils.get_player().global_position.angle_to_point(global_position)
		get_tree().current_scene.add_child(new_blood)
		GameEvents.frameFreeze(0.1, 0.3)
	hit.emit()
	
	
