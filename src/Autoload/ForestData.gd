extends Node

signal tree_count_updated
signal grid_count_updated
signal cell_count_updated

var tree_count: = 0 setget set_tree_count
var grid_count: = [] setget set_grid_count
var cell_count: = 0 setget set_cell_count

func reset() -> void:
	tree_count = 0

func set_tree_count(value:int) -> void:
	tree_count = value
	emit_signal("tree_count_updated")

func set_grid_count(value:Array) -> void:
	grid_count = value
	emit_signal("grid_count_updated")

func set_cell_count(value:int) -> void:
	cell_count = value
	emit_signal("cell_count_updated")
