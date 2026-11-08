extends CanvasLayer

@onready var dialogue_content = $MarginContainer/MarginContainer/HBoxContainer/DialogueContent
@onready var dialogue_end = $MarginContainer/MarginContainer/HBoxContainer/DialogueEnd
@onready var dialogue_box = $"."
@onready var portrait_sprite = $MarginContainer/MarginContainer/HBoxContainer/Portrait/PortraitSprite
@onready var dialogue_sound = $DialogueSound


var reading_tween: Tween

var last_portrait: Texture2D

enum State {
	READY,
	READING,
	FINISHED,
	CLOSING
}

var CPS = 23

var current_state = State.READY

# Called when the node enters the scene tree for the first time.
func _ready():
	close_dialogue_box()
	

func close_dialogue_box():
	dialogue_content.text = ""
	dialogue_end.text = ""
	dialogue_box.hide()
	portrait_sprite.texture = null
	GameManager.is_dialogue_box_active = false
	last_portrait = null
	
func display_text():
	var newest_text: Dictionary = GameManager.text_queue.pop_front()
	dialogue_content.text = newest_text["text"]
	if "portrait" in newest_text:
		portrait_sprite.texture = newest_text["portrait"]
		last_portrait = newest_text["portrait"]
	else:
		if last_portrait != null:
			portrait_sprite.texture = last_portrait
		else:
			portrait_sprite.texture = null

	dialogue_content.visible_ratio = 0
	dialogue_end.text = ""
	dialogue_box.show()
	GameManager.is_dialogue_box_active = true

	dialogue_sound.playing = true
	
	
	change_state(State.READING)
	reading_tween = create_tween()
	reading_tween.tween_property(dialogue_content, "visible_ratio", 1, dialogue_content.text.length()/CPS)
	reading_tween.tween_callback(on_tween_finished)
	
func on_tween_finished():
	change_state(State.FINISHED)
	dialogue_end.text = "V"
	dialogue_sound.playing = false


func change_state(next_state):
	current_state = next_state
	match next_state:
		State.READY:
			print("changing state to: Ready")
		State.READING:
			print("changing state to: Reading")
		State.FINISHED:
			print("changing state to: Finished")
		State.CLOSING:
			print("changing state to: Closing")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match current_state:
		State.READY:
			if !GameManager.text_queue.is_empty():
				display_text()
		State.READING:
			if Input.is_action_just_pressed("interact"):
				reading_tween.kill()
				dialogue_content.visible_ratio = 1
				on_tween_finished()
		State.FINISHED:
			if Input.is_action_just_pressed("interact"):
				change_state(State.CLOSING)
		State.CLOSING:
			if GameManager.text_queue.is_empty():
				close_dialogue_box()
			change_state(State.READY)
