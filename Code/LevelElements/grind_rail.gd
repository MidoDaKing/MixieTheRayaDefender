@tool
extends Path2D

## This will also generate visuals
@export_tool_button("Generate Collision") var col_gen_button: Callable = generate_collision

## The collision polygon will be generated at this size, with the curve centered.
@export var collision_generator_thickness: float

@export_subgroup("Internal", "i_")
@export var i_follower: PathFollow2D
@export var i_collision: CollisionPolygon2D
@export var i_line: Line2D

func _ready():
	generate_collision()

## Adding the points of the line to the top of the collision polygon,
## then adds a copy of the points to the bottom, creating perfect collision.
func generate_collision():
	if i_collision == null: return
	i_collision.polygon = []
	var top: PackedVector2Array
	var bot: PackedVector2Array
	for n in curve.get_baked_points():
		top.append(n - Vector2(0, collision_generator_thickness / 2.0))
		bot.append(n + Vector2(0, collision_generator_thickness / 2.0))
	bot.reverse()
	top.append_array(bot)
	i_collision.polygon = top
	
	i_line.points = curve.get_baked_points()
	i_line.width = collision_generator_thickness
	
	i_follower.v_offset = -(collision_generator_thickness / 2.0) + 1.0

## Override the current PlayerState with StateMachine/GrindRail, when the Player collides with the grindrail.
func _on_area_2d_body_entered(body: CollisionObject2D):
	if Engine.is_editor_hint(): return # If the game isn't running.
	if not body is CharacterBody2D: return
	if not body.has_signal("entered_grindrail"): return
	
	i_follower.progress = curve.get_closest_offset(body.global_position - global_position)
	body.entered_grindrail.emit(i_follower)
	
