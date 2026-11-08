extends CharacterBody2D
@onready var camera_2d: Camera2D = $Camera2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


const SPEED = 80.0

func _ready():
	add_to_group("player")


func _physics_process(delta):

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if !GameManager.is_dialogue_box_active and !GameManager.is_player_warping:
		var direction_x = Input.get_axis("ui_left", "ui_right")
		var direction_y = Input.get_axis("ui_up", "ui_down")
		velocity = Vector2(direction_x, direction_y) * SPEED
		
		if velocity != Vector2(0,0):
			animated_sprite_2d.speed_scale = 1
			if direction_y != 0:
				animated_sprite_2d.play("walk_back" if direction_y < 0 else "walk_forward")
				animated_sprite_2d.flip_h = false
			elif direction_x != 0:
				animated_sprite_2d.play("walk_side")
				animated_sprite_2d.flip_h = direction_x < 0
		else:
			match animated_sprite_2d.animation:
				"walk_forward":
					animated_sprite_2d.play("stand_forward")
				"walk_back":
					animated_sprite_2d.play("stand_back")
				"walk_side":
					animated_sprite_2d.play("stand_side")
			animated_sprite_2d.speed_scale = 0
			animated_sprite_2d.frame = 0


	else:
		match animated_sprite_2d.animation:
			"walk_forward":
				animated_sprite_2d.play("stand_forward")
			"walk_back":
				animated_sprite_2d.play("stand_back")
			"walk_side":
				animated_sprite_2d.play("stand_side")
		velocity = Vector2(0,0)
		animated_sprite_2d.speed_scale = 0
		animated_sprite_2d.frame = 0
	

	move_and_slide()
