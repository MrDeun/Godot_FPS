extends HBoxContainer


@export var randomStrength: float = 10.0
@export var shakeFade:float = 5.0

var rng = RandomNumberGenerator.new()
var shake_str: float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func apply_shake():
	shake_str = randomStrength

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	apply_shake()
	if shake_str > 0:
		shake_str = lerpf(shake_str,0,shakeFade*delta)
		randomStrength -= delta*10.0
	pivot_offset = randomOffset()
	pass

	
func give_shake():
	randomStrength = 5.0
	pass	

func randomOffset() -> Vector2:
	return Vector2(rng.randf_range(-shake_str,shake_str),rng.randf_range(-shake_str,shake_str))
	
