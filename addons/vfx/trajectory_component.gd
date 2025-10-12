class_name TrajectoryComponent
extends Node2D

@export var EXPLOSION_FORCE : float = 500.0
@export var test_projectile : CharacterBody2D
@onready var line_2d: Line2D = $Line2D

func _process(_delta: float) -> void:
	queue_redraw()

func _draw() -> void:
	update_trajectory()
	
func get_forward_direction() -> Vector2:
	return global_position.direction_to(get_global_mouse_position())
	
func draw_line_global(pointA:Vector2, pointB: Vector2, color: Color, width: int = -1) -> void:
	var local_offset := pointA - global_position
	var pointB_local := pointB - global_position
	draw_line(local_offset, pointB_local, color, width)
	
func update_trajectory():
	line_2d.clear_points()
	var velocity : Vector2 = EXPLOSION_FORCE * get_forward_direction()
	var line_start := global_position
	var line_end: Vector2
	var gravity: float = 0.0
	var drag: float = ProjectSettings.get_setting("physics/2d/default_linear_damp")
	var timestep := 0.02
	var colors := [Color.RED, Color.BLUE]
	
	test_projectile.global_position = line_start
	line_2d.add_point(line_2d.to_local(line_start))
	for i:int in 40:
		velocity.y += timestep
		line_end = line_start + (velocity * timestep)
		velocity = velocity * clampf(1.0 - drag * timestep, 0, 1)
		var collision := test_projectile.move_and_collide(velocity * timestep)
		if collision:
			velocity = velocity.bounce(collision.get_normal())
			draw_line_global(line_start, test_projectile.global_position, Color.YELLOW)
			line_2d.add_point(line_2d.to_local(test_projectile.global_position))
			line_start = test_projectile.global_position
			continue
		line_2d.add_point(line_2d.to_local(line_end))
		draw_line_global(line_start, line_end, colors[i%2])
		line_start = line_end
		line_2d.show()
