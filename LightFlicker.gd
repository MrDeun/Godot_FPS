extends OmniLight3D

var interval = 100;
var timer = 0.0;
var rng = RandomNumberGenerator.new()
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timer += delta;
	if timer > interval:
		timer -= interval
	light_energy = (sin(timer*4) + 2.0) / 9
	pass
