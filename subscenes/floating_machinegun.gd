extends Node3D
var time_state = 0
@export var msg_ref: Label

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time_state += delta;
	if(time_state > 1000):
		time_state = 0
	rotation.y += delta*4.0;
	position.y += 0.33*sin(time_state*5.0)/10;
	pass


func _on_area_3d_body_entered(body):
	if body.is_in_group("player"):
		if body.grant_weapon("auto"):
			if msg_ref != null:
				msg_ref.announce("Automatic Bullet Dispenser",5)
				body.play_sound()
			queue_free()
	pass # Replace with function body.
