extends NPC

@export var portrait_neutral: Texture2D
@export var portrait_slightly_animated: Texture2D
# Called when the node enters the scene tree for the first time.

func _ready():
	super._ready()
	text_content = [
			{"text": "I'm stranded in this barren reality.", "portrait": portrait_neutral},
		{"text": "So far there's not much in here, aside from the grass around me..."},
		{"text": "But i hold on to hope that someday, it will change!", "portrait": portrait_slightly_animated }
	]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player_inside and !GameManager.is_dialogue_box_active:
		if Input.is_action_just_pressed("interact"):
			GameManager.queue_text(text_content)
