extends RayCast3D


# Called when the node enters the scene tree for the first time.
func _ready():
	target_position.x = randf_range(-3,3)
	target_position.y = randf_range(-3,3)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
