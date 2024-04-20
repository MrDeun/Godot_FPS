extends Node3D

@onready var anim_play = $machine_anim
const max_ammo = 500
var current_ammo = 100

const ray_range = 100

func deactivate():
	visible = false
	pass
	
func activate():
	visible = true
	anim_play.play("activate")
	await get_tree().create_timer(0.5).timeout
	pass
	
func fire() -> bool:
	if current_ammo > 0 and !anim_play.is_playing():
		current_ammo -= 1
		anim_play.play("assault_fire")
		return true
	else:
		#if !anim_play.is_playing():
			#anim_play.play("click")
		return false
		
func reload() -> bool:
	return false
	
func _ready():
	pass
	
func _process(_delta):
	pass

