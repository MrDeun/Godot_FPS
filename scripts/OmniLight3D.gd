extends OmniLight3D


func got_hit():
	light_energy = 2.5

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if light_energy > 0.0:
		light_energy -= delta*3.0
	elif light_energy < 0.0:
		light_energy = 0.0
	pass
