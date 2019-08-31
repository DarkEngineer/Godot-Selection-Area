extends Area2D
"""
Object responsible for selecting objects and sending them to selected array.
"""
var _details: Dictionary = {
	"top_left": Vector2(0, 0),
	"top_right": Vector2(0, 0),
	"bottom_left": Vector2(0, 0),
	"bottom_right": Vector2(0, 0),
	"width": 0,
	"height": 0
} setget , get_details

onready var _c_shape = $Shape

onready var _overlap_timer = $OverlappingResponseTimer

var _start_mouse_position: Vector2
var _select_started: bool = false

var _selection_mode: int = global.SELECTION_MODE.NONE

signal objects_selected(obj_array, selection_mode)

func _ready():
	pass

func _input(event):
	if event.is_action_pressed("left_mouse"):
		on_action_press()
	if event.is_action_released("left_mouse"):
		on_action_release()

func _process(delta):
	if _select_started:
		var shape_data: Dictionary = set_corner_points_values(_start_mouse_position, 
				get_global_mouse_position())
		set_col_shape_corner_points(shape_data.top_left, shape_data.top_right, 
				shape_data.bottom_left, shape_data.bottom_right)
		var length_data = find_length_properties()
		set_length_properties(length_data.width, length_data.height)

func on_action_press():
	if not _select_started:
		_start_mouse_position = get_global_mouse_position()
		_select_started = true

func on_action_release():
	_select_started = false
	
	var corners_data: Dictionary = set_corner_points_values(_start_mouse_position, get_global_mouse_position())
	
	var tl = corners_data.top_left
	var tr = corners_data.top_right
	var bl = corners_data.bottom_left
	var br = corners_data.bottom_right
	
	set_col_shape_corner_points(tl, tr, bl, br)
	
	set_center()
	set_shape_properties(_details.width, _details.height)
	
	_overlap_timer.start()
	show()

func find_center() -> Vector2:
	var length_properties = find_length_properties()
	var width = length_properties.width
	var height = length_properties.height
	
	var center: Vector2 = Vector2(_details.top_left.x + width / 2.0, _details.top_left.y + height / 2.0)
	
	set_length_properties(width, height)
	
	return center

func find_length_properties() -> Dictionary:
	var width = _details.top_right.x - _details.top_left.x
	var height = _details.bottom_right.y - _details.top_left.y
	
	var return_data = {
		"width": width,
		"height": height
	}
	
	return return_data

func get_details() -> Dictionary:
	return _details

func set_center():
	set_area_position(find_center())

func set_area_position(pos: Vector2):
	set_position(pos)

func set_corner_points_values(start_m_pos, end_m_pos) -> Dictionary:
	var top_left = start_m_pos
	var top_right = Vector2(end_m_pos.x, start_m_pos.y)
	var bottom_left = Vector2(start_m_pos.x, end_m_pos.y)
	var bottom_right = end_m_pos
	
	var return_data = {
		"top_left": top_left,
		"top_right": top_right,
		"bottom_left": bottom_left,
		"bottom_right": bottom_right
	}
	
	return return_data

func set_col_shape_corner_points(tl, tr, bl, br):
	_details.top_left = tl
	_details.top_right = tr
	_details.bottom_left = bl
	_details.bottom_right = br

func set_length_properties(w, h):
	_details.width = w
	_details.height = h

func set_shape_properties(w: float, h: float):
	var shape = _c_shape.get_shape()
	shape.set_extents(Vector2(w / 2.0, h / 2.0))

func set_selection_mode():
	"""
	set if selection is for single object or multiple to choose proper filters
	"""

func _on_OverlappingResponseTimer_timeout():
	emit_signal("objects_selected", get_overlapping_areas())
	hide()
