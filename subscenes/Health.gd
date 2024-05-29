extends Control
@onready var label = $HBoxContainer/PanelContainer2/Label
@onready var player = $"../../../../.."
var ui_health = 100

func update():
	ui_health = player.health
	label.text = str(ui_health)
	
# Called when the node enters the scene tree for the first time.
func _ready():
	update()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
