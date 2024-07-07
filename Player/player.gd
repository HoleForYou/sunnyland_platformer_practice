extends CharacterBody2D

#platformer variables
var max_speed = 250
var acceleration = 10
var  deacceleration = 25

var jump_queue = false
const jump_velocity = -300.0
var can_jump = false

var player_looking_direction = false

var can_take_hurt = true
#interactable variable
var push_force = 80.0

signal player_hurt

@onready var animated_sprite_2d = $AnimatedSprite2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# If standing on floor jump
	if Input.is_action_just_pressed("jump"):
		if is_on_floor() or can_jump:
			jump()
	#if about to land and pressed jump then jump.
	if Input.is_action_just_pressed("jump"):
		if !is_on_floor():
			jump_queue = true
			$CoyoteTimer.start()
	if jump_queue and is_on_floor():
			jump()
			jump_queue = false
	if PlayerData.jump_from_killing_enemy:
		jump()
		PlayerData.jump_from_killing_enemy = false



	# Get the input direction (input_axis) and handle the movement/deceleration.
	var input_axis = Input.get_axis("left", "right")

	#Take the direction of movement  and apply acceleration
	if input_axis == 1:
		if velocity.x <= max_speed:
			velocity.x += acceleration
	elif input_axis == -1:
		if velocity.x >= -max_speed:
			velocity.x -= acceleration
	else:
		#Applies deaccelration to stop the player when the player is not moving.
		if velocity.x > 0:
			velocity.x -= deacceleration
			#without this sometimes the player never comes to a complete stop
			if velocity.x < 0:
				velocity.x = 0
		if velocity.x < 0:
			velocity.x += deacceleration
			#without this sometimes the player never comes to a complete stop
			if velocity.x > 0:
				velocity.x = 0

	move_and_slide()
	update_animations(input_axis)
	coyote_jump()

	#interacting with interactables
	for i in get_slide_collision_count():
		var c = get_slide_collision(i)
		if c.get_collider() is RigidBody2D:
			c.get_collider().apply_central_impulse(-c.get_normal() * push_force)

func jump():
	velocity.y = jump_velocity
func update_animations(input_axis):
	if input_axis != 0:
		animated_sprite_2d.flip_h = input_axis < 0
		animated_sprite_2d.play("run")
		player_looking_direction = true
	else:
		animated_sprite_2d.play("idle")
		player_looking_direction = false

	if not is_on_floor():
		animated_sprite_2d.play("jump")
func coyote_jump():
	if is_on_floor():
		can_jump = true
		$CoyoteTimer.start()
func _on_coyote_timer_timeout():
	can_jump = false
	jump_queue = false
func _on_enemy_detect_body_entered(body):
	if body.is_in_group("enemy") and !PlayerData.jump_from_killing_enemy:
		emit_signal("player_hurt")
func _on_enemy_detect_area_entered(area):
	if area.is_in_group("enemy") and can_take_hurt:
		can_take_hurt = false
		$hurt_cooldown.start()
		emit_signal("player_hurt")
func _on_hurt_cooldown_timeout():
	can_take_hurt = true
