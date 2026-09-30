extends PlayerState

var rail_follower: PathFollow2D
var is_finished := false

func test(_delta: float, _new_input: int, _old_input: int) -> String:
	if _new_input & 0b010000 != 0 and _old_input & 0b010000 == 0:
		is_finished = true
		return "Jump"
	if is_finished: return "Fall"
	
	return "current"

func enter_function(_delta: float, _new_input: int, _old_input: int):
	is_finished = false

func idle_function(_delta: float, _old_input: int):
	## Possibly not the best practice to do the movement in the idle process,
	## but it looked jittery in the physics process, so...
	if is_finished: return
	
	if rail_follower.progress_ratio == 1: is_finished = true
	rail_follower.progress += body.RAIL_SPEED * _delta
	
	if is_finished: return
	
	body.global_position = rail_follower.global_position
	body.global_rotation = rail_follower.global_rotation
	body.up_direction = Vector2.UP.rotated(rail_follower.global_rotation)

func exit_function(_delta: float, _new_input: int, _old_input: int):
	var exit_velocity := Vector2(body.RAIL_SPEED, 0).rotated(rail_follower.global_rotation)
	body.current_ground_speed = exit_velocity.x
	body.velocity.y = exit_velocity.y

func _on_mixie_entered_grindrail(new_rail_follower: PathFollow2D):
	rail_follower = new_rail_follower
