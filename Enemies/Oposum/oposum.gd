extends CharacterBody2D


@export var SPEED = 20
var direction = true

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

#for raycasts
@onready var left_raycast = $left
@onready var right_raycast = $right
@onready var left_down_raycast = $left_down
@onready var right_down_raycast = $right_down
@onready var up_raycast = $up_raycast


func _physics_process(delta):
	# Movement and gravity stuff
	if not is_on_floor():
		velocity.y += gravity * delta
	if !direction:
		velocity.x = SPEED
		$AnimatedSprite2D.flip_h = true
	else:
		velocity.x = -SPEED
		$AnimatedSprite2D.flip_h = false
	move_and_slide()


func _on_direction_cooldown_timeout():
	if left_raycast.is_colliding() or right_raycast.is_colliding():
		direction = !direction
	if !left_down_raycast.is_colliding() or !right_down_raycast.is_colliding():
		direction = !direction


func spawn_feedback():
	var scene_to_spawn = preload("res://Pickups/Feedback/feedback.tscn")
	var new_scene_instance = scene_to_spawn.instantiate()
	get_tree().current_scene.add_child(new_scene_instance)  # Add the instance as a child of the current scene
	new_scene_instance.scale = Vector2(2,2)
	new_scene_instance.global_position = global_position

# plaayer collision
func _on_up_player_detector_body_entered(body):
	if body.is_in_group("player"):
			spawn_feedback()
			PlayerData.points += 500
			PlayerData.jump_from_killing_enemy = true
			queue_free()
