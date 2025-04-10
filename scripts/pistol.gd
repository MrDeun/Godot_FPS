extends Node3D
# Gun Stats
const mag_size = 8
const max_reserve = 80
const ray_range = 100

var damage = 30

@export var ammo_in_mag = 8
@export var reserve = 32

@onready var player_anim := $anim_player
@onready var reload_timer := $reload_timer
@onready var gun_raycast := $"../../../../../../first_person_camera/hit_trail"
@onready var ammo_hud := $"../../../HUD2/Ammo/HBoxContainer/PanelContainer3/Label"

func reload() -> bool:
	if reserve > 0 and !player_anim.is_playing() and ammo_in_mag != mag_size:
		player_anim.play("Reload")
		reload_timer.start()
		return true;
	else:
		return false

func deactivate():
	visible = false
	pass
	
func activate():
	player_anim.play("activate")
	visible = true
	await get_tree().create_timer(0.5).timeout
	pass

func shoot() -> bool:
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
	ammo_hud._ready() 
	
	
