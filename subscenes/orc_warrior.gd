extends CharacterBody3D

var health = 150
var target = null

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@onready var player_path = $"../new_player"
@onready var nav_agent = $NavigationAgent3D

@onready var anim_tree = $AnimationTree
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func got_hit(damage: float):
	health -= damage
	print("CURRENT HEALTH: " + str(health))
	if health <= 0:
		queue_free()
	return

func _physics_process(delta):
	velocity = Vector3.ZERO
	
	#NAVI
	nav_agent.set_target_position(player_path.global_transform.origin)
	var next_nav_point = nav_agent.get_next_path_position()
	velocity = (next_nav_point - global_transform.origin).normalized() * SPEED
	
	look_at(Vector3(player_path.global_position.x,global_position.y,player_path.global_position.z))
	move_and_slide()
	
