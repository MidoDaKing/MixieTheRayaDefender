class_name PlayerState
extends Node

## Whether the state can be overridden by external forces (i.e. grindrails).
@export var overrides_overrides := false
## The CharacterBody2D with the constants used by PlayerStates for Movement.
@export var body: Mixie

## Returns the StringName of another PlayerState under the same parent StateMachine to change to.
## Returns "current" if there is no need to change.
func test(_delta: float, _new_input: int, _old_input: int) -> String:
	return "current"

## Called when the state is the new current_state of the StateMachine (on the physics process).
## Use this to start animations, reset values and anything else that only needs to be done once.
func enter_function(_delta: float, _new_input: int, _old_input: int):
	pass
## Called every frame on the idle process. Prefer physics_function() over this for anything involving body.
func idle_function(_delta: float, _old_input: int):
	pass
## Called every physics frame. Preferred over idle_function() for anything involving body.
func physics_function(_delta: float, _new_input: int, _old_input: int):
	pass
## Called after another state has been chosen (on the physics process).
func exit_function(_delta: float, _new_input: int, _old_input: int):
	pass

## Helper function to apply the directional speed in body.current_ground_speed to the player.velocity.
## If it is fed a non-zero _new_input it will apply that to the body.current_ground_speed before applying
## body.current_ground_speed to the player.velocity. !!!Calls body.move_and_slide()!!!
func do_player_horizontal_movement(_new_input: int, speed_limit: float):
	var direction: int = (_new_input & 0b01) - ((_new_input & 0b10) >> 1)
	if (body.current_ground_speed + (direction * body.ACCELERATION)) * direction <= speed_limit:
		body.current_ground_speed += direction * body.ACCELERATION
	if body.is_on_wall():
		if body.get_wall_normal().x < 0: body.current_ground_speed = clamp(
			body.current_ground_speed, speed_limit * -2, 0
		)
		else: body.current_ground_speed = clamp(
			body.current_ground_speed, 0, speed_limit * 2
		)
	body.velocity.x = body.current_ground_speed
	body.move_and_slide()
