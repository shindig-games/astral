extends Control

onready var start_button = $CenterContainer/VBoxContainer/Start
onready var quit_button = $CenterContainer/VBoxContainer/Quit

func _ready():
	start_button.connect("pressed", self, "_on_start_pressed")
	quit_button.connect("pressed", self, "_on_quit_pressed")

func _on_start_pressed():
	get_tree().change_scene("res://scenes/World.tscn")

func _on_quit_pressed():
	get_tree().quit()
