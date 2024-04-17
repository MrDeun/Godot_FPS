extends Label

@onready var pistol := $"../../../../weapon_rigging/Pistol"


var current_count := 0
var pistol_ammo_pile := 0
# Called when the node enters the scene tree for the first time.
func _ready():
	current_count = pistol.ammo_in_mag
	pistol_ammo_pile = pistol.reserve
	self.text = str(current_count) + " / " + str(pistol_ammo_pile)
	return # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if current_count != pistol.ammo_in_mag or pistol_ammo_pile != pistol.reserve:
		_ready()
	return
