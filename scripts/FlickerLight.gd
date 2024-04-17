extends OmniLight3D

var rng = RandomNumberGenerator.new();

# Called when the node enters the scene tree for the first time.
func _ready():
	light_color = Color8(180,142,73)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	light_energy = (light_energy + rng.randf_range(0.7,1.3))/1.66
	pass
