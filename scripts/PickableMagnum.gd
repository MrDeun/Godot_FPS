extends MeshInstance3D

var initial_position = position.y
var time_state = 0.0

@onready var light_gun := $Sphere/Green_Bulb

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time_state += delta;
	if(time_state > 1000):
		time_state = 0
	rotation.y += delta*4.0;
	position.y = initial_position + 0.33*sin(time_state*5.0)/1;
	pass
