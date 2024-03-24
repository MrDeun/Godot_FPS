extends Node3D
@onready var crosshair := $Control/TextureRect

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	crosshair.position.x = get_viewport().size.x/2
	crosshair.position.y = get_viewport().size.y/2
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
