extends CharacterBody2D

@export var SPEED = 60
var direction = true


@onready var up_raycast = $up_raycast
@onready var down_raycast = $down_raycast


# Called when the node enters the scene tree for the first time.
func _ready():

	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if down_raycast.is_colliding():
		direction = false
		$movement_cooldown.start()
	if !direction:
		velocity.y = -SPEED
	else:
		velocity.y = SPEED
	move_and_slide()
func _on_movement_cooldown_timeout():
	direction = true

func spawn_feedback():
	var scene_to_spawn = preload("res://Pickups/Feedback/feedback.tscn")
	var new_scene_instance = scene_to_spawn.instantiate()
	get_tree().current_scene.add_child(new_scene_instance)  # Add the instance as a child of the current scene
	new_scene_instance.scale = Vector2(2,2)
	new_scene_instance.global_position = global_position

#player collision
func _on_up_player_detecter_body_entered(body):
	if body.is_in_group("player"):
			spawn_feedback()
			PlayerData.points += 1000
			PlayerData.jump_from_killing_enemy = true
			queue_free()
