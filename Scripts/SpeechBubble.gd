extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var text_idx = 0
var typing_time = 0
var next_type = []
var current_text = ""

export(Array, String, MULTILINE) var text = []
export(NodePath) var parentTo
export(float) var typingDelay = 0.1

# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalVars.speechBubble = self
	if (text.size() > 0):
		begin_type(text[0])
	
func next():
	text_idx += 1
	if (text_idx >= text.size()):
		queue_free()
	else:
		begin_type(text[text_idx])

func begin_type(txt):
	$BubbleTextLabel.parse_bbcode("")
	next_type = []
	for n in txt.length():
		next_type.push_back(txt[n])
	typing_time = 0
	current_text = ""

func set_text(txt):
	$BubbleTextLabel.parse_bbcode("[center]" + txt + "[/center]")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	typing_time += delta
	if (typing_time > typingDelay):
		typing_time = 0
		if (next_type.size() > 0):
			current_text += next_type.pop_front()
			set_text(current_text)
