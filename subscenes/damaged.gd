extends ColorRect

func got_hit(percent:float):
	print("DAMANGED RECEIVED!")
	color.a = 0.66

# Called when the node enters the scene tree for the first time.
func _ready():
	color.a = 0
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if color.a > 0:
		color.a -= 0.03
	pass
