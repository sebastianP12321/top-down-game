extends Node2D

@onready var color_rect: ColorRect = $CanvasLayer/ColorRect

@export var level_default: PackedScene

@export var player: PackedScene


func _ready():
	
	color_rect.modulate.a = 0.0
	
	call_deferred("_focus_window")
	var player_scene_instance = player.instantiate()
	var default_level_instance = level_default.instantiate()
	player_scene_instance.set_global_position(Vector2(150,170))
	
	$CurrentLevel.add_child(default_level_instance)
	
	var tile_reference = default_level_instance.find_child("BackgroundTiles")
	
	var used_rect = tile_reference.get_used_rect()
	
	var top_left = tile_reference.to_global(tile_reference.map_to_local(used_rect.position))
	
	var bottom_right = tile_reference.to_global(tile_reference.map_to_local(used_rect.end))
	
	default_level_instance.add_child(player_scene_instance)
	
	player_scene_instance.camera_2d.limit_left = int(top_left.x)
	player_scene_instance.camera_2d.limit_top = int(top_left.y)
	player_scene_instance.camera_2d.limit_right = int(bottom_right.x-16)
	player_scene_instance.camera_2d.limit_bottom = int(bottom_right.y-16)
	
	


	



func _focus_window():
	get_window().grab_focus()
# Called every frame. 'delta' is the elapsed time since the previous frame.


func _process(delta):
	pass
	
	
	
	
	
