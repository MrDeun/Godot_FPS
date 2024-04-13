extends Node3D
# Gun Stats
const mag_size = 8
const max_reserve = 80
const ray_range = 100

var ammo_in_mag = 8
var reserve = 32

@onready var player_anim := $anim_player
@onready var sphere_collision := $"../../../../HighCalibler/Sphere"

func reload() -> bool:
	if ammo_in_mag != 8 and !player_anim.is_playing() and reserve > 0:
		player_anim.play("Reload")
		while (player_anim.is_playing()):
			continue
		if reserve >= 8:
			if ammo_in_mag == 0:
				ammo_in_mag = mag_size
				reserve -= mag_size
			else:
				var missing_bullets: int = mag_size - ammo_in_mag
				ammo_in_mag += missing_bullets
				reserve -= missing_bullets
			return true
		else:
			ammo_in_mag = reserve
			reserve -= reserve
			return true
	return false
	
func shoot() -> bool:
	print(player_anim.is_playing())
	if ammo_in_mag > 0 and !player_anim.is_playing():
		ammo_in_mag -= 1;
		player_anim.play("Fire")
		return true
	else:
		if !player_anim.is_playing():
			player_anim.play("click")
		return false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
