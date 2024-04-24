extends StaticBody3D
@onready var green_buln := $Green_Bulb

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func got_hit():
	green_buln.got_hit()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
