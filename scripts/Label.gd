extends Label

@onready var player_instance := $"../../../../.."

var current_count := 0
# Called when the node enters the scene tree for the first time.
func _ready():
	match player_instance.current_weapon:
		player_instance.weapons.PISTOL:
			current_count = player_instance.pistol.ammo_in_mag
		player_instance.weapons.AUTO:
			current_count = player_instance.auto.current_ammo
	text = str(current_count)
	return # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match player_instance.current_weapons:
		player_instance.weapons.PISTOL:
			if current_count != player_instance.pistol.ammo_in_mag:
				_ready()
		player_instance.weapons.AUTO:
			if current_count != player_instance.auto.current_ammo:
				_ready()
	return
