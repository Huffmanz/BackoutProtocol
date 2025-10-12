extends Line2D

const TIME_STEP := 0.04

@export var max_points := 32

var time_left := 0.0

func _ready() -> void:
	points.clear()
	top_level = true

func _process(delta: float) -> void:
	time_left -= delta
	
	if time_left <= 0:
		time_left = TIME_STEP
		add_point_to_line()

func add_point_to_line():
	add_point(get_parent().global_position)
	show()
	
	if get_point_count() > max_points:
		remove_point(0)
