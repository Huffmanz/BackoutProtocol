class_name LightDetector
extends Area2D

signal light_detected(light_detected: bool)

func _ready():
    area_entered.connect(on_area_entered)
    area_exited.connect(on_area_exited)

func on_area_entered(_other_area:Area2D):
    light_detected.emit(true)

func on_area_exited(_other_area:Area2D):
    light_detected.emit(false)