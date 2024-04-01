extends Node3D

var ammo_in_mag = 8

@onready var player_anim := $anim_player
@onready var sphere_collision := $"../../../../HighCalibler/Sphere"

func reload():
	if ammo_in_mag != 8 and !player_anim.is_playing():
		player_anim.play("Reload")
		ammo_in_mag = 8
		
func shoot() -> bool:
	if ammo_in_mag > 0 and !player_anim.is_playing():
		ammo_in_mag -= 1;
		player_anim.play("Fire")
		return true
	else:
		reload()
		return false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
