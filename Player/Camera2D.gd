extends Camera2D

#customisable variables
@export var random_strength: float = 30.0
@export var shake_fade: float = 5.0

#important unchyangeable variables, not customisable
var rng = RandomNumberGenerator.new()
var shake_strength: float = 0.0

func apply_shake():
	shake_strength = random_strength

func _process(delta):
	if shake_strength > 0:
		shake_strength = lerpf(shake_strength,0,shake_fade * delta)
		offset = random_offset()

func random_offset() ->Vector2:
	return(Vector2(rng.randf_range(-shake_strength,shake_strength),rng.randf_range(-shake_strength,shake_strength)))


func _on_player_player_hurt():
	apply_shake()
