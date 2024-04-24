extends Label

@onready var player_instance := $"../../../../../../../.."
@onready var pistol := $"../../../../../weapon_camera/Weapon_Rig/Pistol"
@onready var machine_gun := $"../../../../../weapon_camera/Weapon_Rig/MachineGun"

var current_count := 0
var current_mag := 0
# Called when the node enters the scene tree for the first time.
func _ready():
	match player_instance.current_weapon:
		player_instance.weapons.PISTOL:
			if pistol.reserve < 10:
				text = str(pistol.ammo_in_mag) + "/ " + str(pistol.reserve) 
			else:
				text = str(pistol.ammo_in_mag) + "/" + str(pistol.reserve)
			current_count = pistol.ammo_in_mag + pistol.reserve
			current_mag = pistol.ammo_in_mag
		player_instance.weapons.AUTO:
			if machine_gun.current_ammo < 100:
				text = "  " + str(machine_gun.current_ammo)
			elif machine_gun.current_ammo < 10:
				text = "     " + str(machine_gun.current_ammo)
			else:
				text = " " + str(machine_gun.current_ammo)
			current_count = machine_gun.current_ammo
			current_mag = -1
		_:
			text = "ERROR"
	return # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match player_instance.current_weapon:
		player_instance.weapons.PISTOL:
			if current_count != pistol.ammo_in_mag + pistol.reserve and current_mag != pistol.ammo_in_mag:
				_ready()
		player_instance.weapons.AUTO:
			if current_count != machine_gun.current_ammo:
				_ready()
		_:
			pass
	return
