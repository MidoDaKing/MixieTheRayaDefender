extends PlayerState


func physics_function(_delta: float, _new_input: int, _old_input: int):
	# The Sandstorm's script controls body.velocity.y directly
	do_player_horizontal_movement(_new_input, body.MAX_AIR_SPEED)
