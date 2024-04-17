extends Node3D

var weapon_stash = []
var weapon_list = {}

var current_weapon = null
var weapon_stash_index = 0
var next_weapon: String
@export var _weapon_resources: Array[PackedScene]
@export var starter_weapons: Array[String]
# Called when the node enters the scene tree for the first time.
func _ready():
	init()
	pass # Replace with function body.

func init():
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
func Change_Weapons():
	pass
