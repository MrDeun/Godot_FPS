extends CharacterBody3D

var health = 100
var target = null
var state_machine

const SPEED = 2.0
const ATTACK_RANGE = 2.5
const JUMP_VELOCITY = 4.5

@onready var player_path = $"../new_player"
@onready var nav_agent = $NavigationAgent3D
@onready var blood = $BloodDecal

@onready var anim_tree = $AnimationTree
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func got_hit(damage: float):
	health -= damage
	print("CURRENT HEALTH: " + str(health))
	blood.emitting = true
	await get_tree().create_timer(0.1).timeout
	blood.emitting = false	
	if health <= 0:
		queue_free()
	return

func _ready():
	state_machine = anim_tree.get("parameters/playback")
	blood.emitting = false
	
func _target_in_range():
	return global_position.distance_to(player_path.global_position) <= ATTACK_RANGE

func _physics_process(delta):
	velocity = Vector3.ZERO
	match state_machine.get_current_node():
		"root|walking":
			nav_agent.set_target_position(player_path.global_transform.origin)
			var next_nav_point = nav_agent.get_next_path_position()
			velocity = (next_nav_point - global_transform.origin).normalized() * SPEED
			look_at(Vector3(global_position.x + velocity.x ,global_position.y,global_position.z + velocity.z),Vector3.UP)			
			pass
		"root|attackA":
			look_at(Vector3(player_path.global_position.x,global_position.y,player_path.global_position.z),Vector3.UP)
			pass	
		
	anim_tree.set("parameters/conditions/attack",_target_in_range())
	anim_tree.set("parameters/conditions/run", !_target_in_range())
	
	state_machine = anim_tree.get("parameters/playback")
	move_and_slide()
	
