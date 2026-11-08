extends Node



var player_scene = preload("res://Scenes/Functional/player.tscn")

var color_rect: ColorRect

var player_sprite

var fade_out_tween: Tween

func _ready() -> void:
	color_rect = get_tree().current_scene.find_child("ColorRect", true, false)


var all_levels: Dictionary = {
	"level_1": "res://Scenes/Levels/level_1.tscn",
	"level_2": "res://Scenes/Levels/level_2.tscn"
}
func warp_player(target_level_path: String, target_spawnpoint: String, target_direction: String):
	GameManager.is_player_warping = true
	fade_out_tween = create_tween()
	fade_out_tween.tween_property(color_rect, "modulate:a", 1.0, 0.5)
	fade_out_tween.tween_callback(warp_player_finalize.bind(target_level_path, target_spawnpoint, target_direction))
	
	

func warp_player_finalize(target_level_path: String, target_spawnpoint: String, target_direction: String):
	var target_level: PackedScene = load(target_level_path)
	var target_level_instance = target_level.instantiate()
	var player_scene_instance = player_scene.instantiate()
	var world_tree = get_tree().current_scene
	
	for child in world_tree.get_node("CurrentLevel").get_children():
		child.queue_free()
	
	world_tree.get_node("CurrentLevel").add_child(target_level_instance)
	player_scene_instance.global_position = target_level_instance.find_child(target_spawnpoint, true, false).global_position
	
	player_sprite = player_scene_instance.find_child("AnimatedSprite2D")
	
	match target_direction:
		"up":
			player_sprite.animation = "stand_back"
		"down":
			player_sprite.animation = "stand_forward"
		"left":
			player_sprite.animation = "stand_side"
			player_sprite.flip_h = true
		"right":
			player_sprite.animation = "stand_side"
			player_sprite.flip_h = false
	
	target_level_instance.add_child(player_scene_instance)
	player_scene_instance.camera_2d.make_current()
	
	var tile_reference = target_level_instance.find_child("BackgroundTiles")
	var used_rect = tile_reference.get_used_rect()
	var top_left = tile_reference.to_global(tile_reference.map_to_local(used_rect.position))
	var bottom_right = tile_reference.to_global(tile_reference.map_to_local(used_rect.end))

	
	player_scene_instance.camera_2d.limit_left = int(top_left.x)
	player_scene_instance.camera_2d.limit_top = int(top_left.y)
	player_scene_instance.camera_2d.limit_right = int(bottom_right.x-16)
	player_scene_instance.camera_2d.limit_bottom = int(bottom_right.y-16)
	
	fade_out_tween = create_tween()
	fade_out_tween.tween_property(color_rect, "modulate:a", 0.0, 0.5)
	fade_out_tween.tween_callback(warp_player_unlock_walking)


func warp_player_unlock_walking():
	
	GameManager.is_player_warping = false
