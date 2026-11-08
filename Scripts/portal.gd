extends Area2D


@export var portal_target_level: String
@export var portal_target_spawnpoint: String
@export var portal_target_direction: String

func _on_body_entered(body):
	if body.is_in_group("player"):
		PortalManager.call_deferred("warp_player", PortalManager.all_levels[portal_target_level], portal_target_spawnpoint, portal_target_direction)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
