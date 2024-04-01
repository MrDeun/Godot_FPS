extends Label

@onready var pistol := $"../../../../Pistol"


var current_count := 0
# Called when the node enters the scene tree for the first time.
func _ready():
	current_count = pistol.ammo_in_mag
	self.text = str(current_count)
	return # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if current_count != pistol.ammo_in_mag:
		_ready()
	return
