extends Node2D

var Select_Area = preload("res://SelectArea/SelectArea.tscn")

var _selected = [] setget , get_selected

func _ready():
	create_selection_area_object()

func get_selected():
	return _selected.duplicate()

func create_selection_area_object():
	var s_area = Select_Area.instance()
	s_area.set_name("SelectArea")
	s_area.connect("objects_selected", self, "_on_objects_selected")
	add_child(s_area)

func filter_selection(selected_array: Array, current_selection_array: Array):
	var to_unselection = []
	var duplicates = []
	var new_selection = []
	for new_obj in current_selection_array:
		if selected_array.has(new_obj):
			duplicates.append(new_obj)
			selected_array.erase(new_obj)
		else:
			new_selection.append(new_obj)
	to_unselection = selected_array
	for unselect_obj in to_unselection:
		unselect_obj.set_deselected()

func filter_object_selection(obj_array):
	var filtered_objects = []
	for obj in obj_array:
		var obj_groups = obj.get_groups()
		for group in obj_groups:
			if global._galaxy_select_filter.basic.has(group):
				filtered_objects.append(obj)
				break
	print(filtered_objects)
	return filtered_objects

func _on_objects_selected(obj_array):
	var filtered_obj_array = filter_object_selection(obj_array)
	filter_selection(get_selected(), obj_array)
