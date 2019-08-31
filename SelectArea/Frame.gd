extends Node2D

var _frame_coords: Dictionary = {
	"starting_point": null,
	"width": null,
	"height": null
}

#var _rect_color = Color(0.3, 0.47, 0.7, 0.69)
onready var _color_rect = $Rect

var _continue_frame_drawing = false


const _line_color = Color.antiquewhite
const _line_width = 4.0

func _ready():
	pass

func _process(delta):
	if owner._select_started:
		if not _continue_frame_drawing:
			_frame_coords.starting_point = get_viewport().get_mouse_position()
			_continue_frame_drawing = true
			set_position(_frame_coords.starting_point)
		show()
		calculate_size()
		render_rect()
		
	elif not owner._select_started:
		if _continue_frame_drawing:
			_continue_frame_drawing = false
		if is_visible_in_tree():
			hide()

func calculate_size():
	var current_m_pos = get_viewport().get_mouse_position()
	var width = current_m_pos.x - _frame_coords.starting_point.x
	var height = current_m_pos.y - _frame_coords.starting_point.y
	_frame_coords.width = width
	_frame_coords.height = height

func render_rect():
	if _frame_coords.width < 0:
		_color_rect.set_scale(Vector2(-1, _color_rect.get_scale().y))
	else:
		_color_rect.set_scale(Vector2(1, _color_rect.get_scale().y))
	if _frame_coords.height < 0:
		_color_rect.set_scale(Vector2(_color_rect.get_scale().x, -1))
	else:
		_color_rect.set_scale(Vector2(_color_rect.get_scale().x, 1))
	_color_rect.set_size(Vector2(abs(_frame_coords.width), abs(_frame_coords.height)))

