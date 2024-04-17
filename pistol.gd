extends Node3D
# Gun Stats
const mag_size = 8
const max_reserve = 80
const ray_range = 100

@export var ammo_in_mag = 8
@export var reserve = 32

@onready var player_anim := $anim_player
@onready var sphere_collision := $"../../../../HighCalibler/Sphere"
@onready var reload_timer := $reload_timer
func reload() -> bool:
	if reserve > 0 and !player_anim.is_playing() and ammo_in_mag != 8:
		player_anim.play("Reload")
		reload_timer.start()
		return true;
	else:
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
	
func _on_reload_timer_timeout():
	var missing: int = mag_size - ammo_in_mag;
	if missing > reserve:
		ammo_in_mag += reserve
		reserve = 0
	else:
		ammo_in_mag += missing
		reserve -= missing
	
	
