extends PlayerState

var timer := 0.0
var go_to_wallslide := false
var left_original_wall := false

func test(_delta: float, _new_input: int, _old_input: int) -> String:
	if go_to_wallslide: return "WallSlide"
	if timer < body.WALL_JUMP_TIME and not body.is_on_ceiling(): return "current"
	return "Fall"

func enter_function(_delta: float, _new_input: int, _old_input: int):
	timer = 0.0
	go_to_wallslide = false
	
	var dir: int
	for n in [body.left_wall_jump_area, body.right_wall_jump_area]:
		if n.has_overlapping_bodies(): dir = -int(n.name)
	var input_direction: int = (_new_input & 0b01) - ((_new_input & 0b10) >> 1)
	if input_direction != 0:
		body.velocity = (body.up_direction * body.WALL_JUMP_STRENGTH.y)
		body.current_ground_speed += (dir * body.WALL_JUMP_STRENGTH.x)
	else:
		timer = body.WALL_JUMP_TIME
		body.velocity = (body.up_direction * body.WALL_SCALE_STRENGTH)
		
	body.move_and_slide()

func physics_function(_delta: float, _new_input: int, _old_input: int):
	timer += _delta
	do_player_horizontal_movement(0, body.MAX_AIR_SPEED)
	if body.is_near_wall():
		if left_original_wall: go_to_wallslide = true
	elif left_original_wall: go_to_wallslide = false
	else: left_original_wall = false
