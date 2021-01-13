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
		var cell = Map.world_to_map(pos)
		# if mouse is on the map add tree
		if Map.get_cellv(cell) == 0:
			Map.set_cell(cell.x,cell.y,2)
		elif Map.get_cellv(cell) == 2:
			Map.set_cell(cell.x,cell.y,0)

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

# Function convert cell id to cartesian coordinates
func get_cell_coordinates(cell:Vector2) -> Vector2:
	return isometric_to_cartesian(Map.map_to_world(Vector2(cell.x,cell.y)))

# Function to update tree and cell counters
func _update_counters(vector:Vector2) -> void:
	# Number of trees
	ForestData.tree_count += 1
	
	# Number of trees per cell
	var cell = Map.world_to_map(vector)
	grid[cell.x][cell.y] += 1
	ForestData.grid_count = grid

func setup_ui() -> void:
	UI.get_node("Background/TitleOverlay").text = "Level 4: Inhom. Poisson"
	UI.get_node("Lambda").visible = false
	UI.get_node("SliderMenu/SimTrees").visible = false
	UI.get_node("SliderMenu/TreeSlider").visible = false
	UI.get_node("SliderMenu/LambdaSlider").visible = true
	UI.get_node("SliderMenu/LambdaTrees").visible = true
	UI.get_node("SliderMenu/Lambda2Slider").visible = true
	UI.get_node("SliderMenu/Lambda2Trees").visible = true
	UI.get_node("OverlayMenu/GridButton").visible = false
	UI.get_node("OverlayMenu/GraphButton").visible = false
	UI.get_node("OverlayMenu/ModelButton").visible = false
# Point Processes
# =============================================================================
# generate a random point on the isometric map
func random_iso_point(cell:Vector2) -> Vector2:
	var point: = Vector2.ZERO
	point.x = rand_range(cell.x,cell.x+tile_size.x/2)
	point.y = rand_range(cell.y,cell.y+tile_size.y)
	return cartesian_to_isometric(point)

# Add tree to the map
func add_tree(cell:Vector2) -> void:
	var new_tree = Trees.instance()
	new_tree.position = random_iso_point(cell)
	Forest.add_child(new_tree)
	
	# Update counters
	_update_counters(new_tree.position)

# generate poisson random variable
func random_poisson(lambda:float) -> int:
	var t: = 0.0 #initialize sum of exponential variables as zero
	var N: = -1 #initialize counting variable as negative one
	
	while t <= 1.0:
		var E: = -(1/lambda) * log(randf()) # generate exponential random variable
		t += E # update sum of exponential variables
		N += 1 # update number of exponential variables

	return N
# Actions (Buttons)
# =============================================================================
# Run
# ---
func run()->void:
	
	var lambda1 = UI.lambda_slider.value
	var lambda2 = UI.lambda2_slider.value
	
	for x in range(grid_size.x):
			for y in range(grid_size.y):
				var N = random_poisson(lambda1)
				if Map.get_cellv(Vector2(x,y)) == 2:
					N = random_poisson(lambda2)
				for n in range(N):
					add_tree(get_cell_coordinates(Vector2(x,y)))

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

