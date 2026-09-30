extends PlayerState

## The amount of time that has passed since entering the PlayerState.
## Used to hold jumps for extra height.
var timer := 0.0

func test(_delta: float, _new_input: int, _old_input: int) -> String:
	if _new_input & 0b010000 != 00 and timer < body.MAX_JUMP_TIME:
		return "current"
	return "Fall"

func enter_function(_delta: float, _new_input: int, _old_input: int):
	timer = 0.0
	if _old_input & 0b0100 != 0 or _new_input & 0b0100 != 0: # If down is held, down jump,
		body.velocity -= body.up_direction * body.JUMP_STRENGTH 
	else: body.velocity += body.up_direction * body.JUMP_STRENGTH # otherwise normal jump.
	body.move_and_slide()

func physics_function(_delta: float, _new_input: int, _old_input: int):
	timer += _delta
	
	do_player_horizontal_movement(_new_input, body.MAX_AIR_SPEED)
