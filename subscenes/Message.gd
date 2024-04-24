extends Label

func announce(text_in:String, time: int):
	text = text_in
	visible = true
	await get_tree().create_timer(time).timeout
	visible = false
# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
