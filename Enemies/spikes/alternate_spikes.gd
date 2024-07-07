extends Area2D


@onready var anim = $animation
func _ready():
	anim.play("down")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_animation_animation_finished(anim_name):
	if anim_name == "down":
		anim.play("up")
	else: anim.play("down")



func _on_body_entered(body):
	pass # Replace with function body.
