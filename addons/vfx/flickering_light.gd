extends PointLight2D

@export var flash_amt: float = 10
@onready var timer = $Timer


func _ready():
	timer.timeout.connect(on_timer_timeout)


func on_timer_timeout():
	var rand_amt := (randf())
	energy = rand_amt
	
	if rand_amt < .5:
		energy = 1
	elif rand_amt > .75:
		energy = .75
	timer.start(rand_amt/randf_range(1, flash_amt))
	
