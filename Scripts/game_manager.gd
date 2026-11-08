extends Node

var text_queue: Array = []

var is_dialogue_box_active := false
var is_player_warping := false

#portal stuff
var warp_level: String
var warp_spawn: String
var warp_player_direction: String

func queue_text(text_entry: Array[Dictionary]):
	GameManager.text_queue.append_array(text_entry)


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
