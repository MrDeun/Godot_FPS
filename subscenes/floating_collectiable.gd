extends Node3D

@onready var machine_gun = $"."
@onready var body = $"../new_player"
@export var msg_ref: Label 
var initial_position = position.y
var time_state = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time_state += delta;
	if(time_state > 1000):
		time_state = 0
	rotation.y += delta*4.0;
	position.y += (initial_position + 0.33*sin(time_state*5.0))/10;
	pass

func _on_area_3d_body_entered(body):
	if body.is_in_group("player"):
		if body.grant_ammo("auto_ammo",50):
			if msg_ref != null:
				msg_ref.announce("+50 automatic ammo",3)
				body.play_sound()
			queue_free()
	pass # Replace with function body.
