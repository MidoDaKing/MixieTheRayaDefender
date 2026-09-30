class_name Mixie
extends CharacterBody2D

## Used to switch to the relevant PlayerState by the StateMachine.
signal entered_sandstorm
## Used to switch to the relevant PlayerState by the StateMachine.
signal exited_sandstorm
## Used to switch to the relevant PlayerState by the StateMachine.
signal entered_grindrail(rail_follower: PathFollow2D)

## At Mixie's feet, pointed downwards, for buffering jumps.
@export var ground_ray: RayCast2D
## Used internally for is_near_wall().
@export var left_wall_jump_area: Area2D
## Used internally for is_near_wall().
@export var right_wall_jump_area: Area2D

## Mixie's maximum horizontal speed while on the ground.
const MAX_GROUND_SPEED = 625.0
## Mixie's maximum horizontal speed while in the air.
const MAX_AIR_SPEED = 450.0
## Used by PlayerState.do_player_horizontal_movement() as a multiplier for input.
const ACCELERATION = 12.5
## Used by StateMachine/Slowing as a multiplier for decelerating.
const FRICTION = 25.0

## Used by StateMachine/Slowing as a multiplier for body.get_gravity().
const WALL_SLIDE_GRAVITY = 0.25
## The positive value used for wall jumps. .x should be multiplied by the desired direction.
## and .y should be multiplied by body.up_direction.
const WALL_JUMP_STRENGTH = Vector2(360.0, 240.0)
## A seperate value for "wall-scale-jumps" (a mechanic similar to "neutrals" in Celeste).
const WALL_SCALE_STRENGTH = 480.0
## The amount of time before the player regains control after a wall jump.
const WALL_JUMP_TIME = 0.375

## How high the player will jump. Should be multiplied by body.up_direction.
const JUMP_STRENGTH = 320.0
## The amount of time the player can hold the jump button for additional height.
const MAX_JUMP_TIME = 0.25
## The amount of time after walking off of a cliff before the player will enter StateMachine/Fall.
const COYOTE_TIME = 0.125

## The speed at which the PathFollow2D travels along the Path2D. Should be multiplied by delta.
const RAIL_SPEED = 1080.0

## Applied to velocity.x when the game isn't paused. The "ground" part is something of a misnomer.
var current_ground_speed: float = 0.0

## I don't like how is_on_wall() works, so use this instead.
## It uses left_wall_jump_area and right_wall_jump_area internally.
func is_near_wall() -> bool:
	var bodies: Array[Node2D] = left_wall_jump_area.get_overlapping_bodies()
	bodies.append_array(right_wall_jump_area.get_overlapping_bodies())
	
	while bodies.has(self):
		bodies.erase(self)
	
	return bodies.size() > 0
