tool
extends Node2D

# Declare member variables here.
# ------------------------------
onready var Map: TileMap = get_node("Map")
onready var Forest: YSort = get_node("Map/Forest")
onready var Trees = preload("res://src/Objects/Tree.tscn")
onready var Camera: Camera2D = get_node("Camera")
onready var UI: Control = get_node("UserInterface/UserInterface")

# Initialize local variables
# --------------------------

# Variables which can be modified in the editor
export(int, 1, 10) var grid_size_x: = 10
export(int, 1, 10) var grid_size_y: = 10

# Local variables
var grid_size: = Vector2(grid_size_x, grid_size_y)
var tile_size: = Vector2.ZERO
var max_size: = Vector2.ZERO
var grid: = []
var is_grid: = false
var is_mouse: = true

# Setup function
# --------------

func _ready():
	
	# Initalize random variables
	randomize()
	
	# Calculate Variables
	tile_size = Map.get_cell_size()
	max_size = get_max_size(tile_size)
	
	# Center camera offset and zoom
	Camera.offset.y = max_size.y/2
	Camera.zoom = get_zoom()
	
	# Generate Map
	generate_map()
	
	# Generate Cell Matrix
	generate_matrix()

	# Setup UI
	setup_ui()
	
	# Reset
	reset()

func _input(event):
   # Mouse in viewport coordinates.
	if (event is InputEventMouseButton and event.pressed) and is_mouse:
		var pos = get_global_mouse_position()
		
		# if mouse is on the map add tree
		if Map.get_cellv(Map.world_to_map(pos)) > -1:
			
			# Add tree on mous position
			var new_tree = Trees.instance()
			new_tree.position = pos
			Forest.add_child(new_tree)
	
			# Update counters
			_update_counters(new_tree.position)

func generate_matrix() -> void:
	for x in range(grid_size.x):
			grid.append([])
			for y in range(grid_size.y):
				grid[x].append(0)
				ForestData.cell_count += 1

# Function to generate empty map
func generate_map(type:int=0) -> void:
	for x in range(grid_size.x):
			for y in range(grid_size.y):
				Map.set_cell(x,y,type)


# Helper functions
# ----------------

# Function to calculate the max size in global coordinates
func get_max_size(tile_size:Vector2) -> Vector2:
	return Vector2((grid_size.x*tile_size.x)/2,grid_size.y*tile_size.y)

# Function to get the inital zoom level
func get_zoom() -> Vector2:
	var zoom: = max_size.y/get_viewport().get_visible_rect().size.y
	if zoom < 1:
		return Vector2(1.0,1.0)
	else:
		return Vector2(zoom,zoom)

# Function to convert cartesian coordinates to isometric coordinates
func cartesian_to_isometric(vector) -> Vector2:
	return Vector2(vector.x - vector.y, (vector.x + vector.y) / 2)

# Function to convert isometric coordinates to cartesian coordinates
func isometric_to_cartesian(vector) -> Vector2:
	var out: = Vector2()
	out.x = (vector.x + vector.y * 2) / 2
	out.y = -vector.x + + out.x
	return out

# Function to update tree and cell counters
func _update_counters(vector:Vector2) -> void:
	# Number of trees
	ForestData.tree_count += 1
	
	# Number of trees per cell
	var cell = Map.world_to_map(vector)
	grid[cell.x][cell.y] += 1
	ForestData.grid_count = grid

func setup_ui() -> void:
	UI.get_node("Background/TitleOverlay").text = "Level 1: Det vs Rand"
	UI.get_node("Lambda").visible = false
	UI.get_node("SliderMenu/LambdaSlider").visible = false
	UI.get_node("SliderMenu/LambdaTrees").visible = false
	UI.get_node("OverlayMenu/GridButton").visible = false
	UI.get_node("OverlayMenu/GraphButton").visible = false
	UI.get_node("OverlayMenu/ModelButton").visible = false
# Point Processes
# =============================================================================
# generate a random point on the isometric map
func random_iso_point() -> Vector2:
	var point: = Vector2.ZERO
	point.x = rand_range(0.0,max_size.x)
	point.y = rand_range(0.0,max_size.y)
	return cartesian_to_isometric(point)

# add tree to the map
func add_tree() -> void:
	var new_tree = Trees.instance()
	new_tree.position = random_iso_point()
	Forest.add_child(new_tree)
	
	# Update counters
	_update_counters(new_tree.position)

# Actions (Buttons)
# =============================================================================
# Run
# ---
func run()->void:
	var num_of_trees = UI.sim_slider.value
	for i in range(num_of_trees):
		add_tree()
	

# Reset
# -----
func reset() -> void:
	# Iterate over all trees and remove them
	for tree in Forest.get_children():
		Forest.remove_child(tree)
	ForestData.tree_count = 0
	
	for x in range(len(grid)):
		for y in range(len(grid)):
			grid[x][y] = 0
	ForestData.grid_count = grid

# Reset
# -----
func grid_view() -> void:
	# Iterate over all trees and remove them
	if is_grid:
		generate_map(0)
		is_grid = false
	else:
		generate_map(1)
		is_grid = true
		
