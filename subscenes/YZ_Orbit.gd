extends MeshInstance3D

var time = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time += delta
	if time > 2000:
		time -= 2000
	position.y = 2.4 * sin(time*3)
	position.z = 2.4 * cos(time*3)
	pass
