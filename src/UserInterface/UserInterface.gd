extends Control

onready var scene_tree: = get_tree()
onready var tree_count: Label = get_node("TreeCount")
onready var cell_count: Label = get_node("CellCount")
onready var sim_count: Label = get_node("SliderMenu/SimTrees")
onready var lambda_value: Label = get_node("SliderMenu/LambdaTrees")
onready var lambda_slider: HSlider = get_node("SliderMenu/LambdaSlider")
onready var lambda2_value: Label = get_node("SliderMenu/Lambda2Trees")
onready var offspring_slider: HSlider = get_node("SliderMenu/OffspringSlider")
onready var offspring_value: Label = get_node("SliderMenu/OffspringTrees")
onready var radius_slider: HSlider = get_node("SliderMenu/RadiusSlider")
onready var radius_value: Label = get_node("SliderMenu/Radius")

onready var lambda2_slider: HSlider = get_node("SliderMenu/Lambda2Slider")

onready var lambda: Label = get_node("Lambda")
onready var sim_slider: HSlider = get_node("SliderMenu/TreeSlider")
onready var hist = get_node("Histogramm")
onready var is_model:= false
onready var is_hist:= false

func _ready() -> void:
	ForestData.connect("tree_count_updated", self, "update_interface")
	ForestData.connect("cell_count_updated", self, "update_interface")
	ForestData.connect("grid_count_updated", self, "update_plot")
	update_interface()
	
	
func update_interface() -> void:
	tree_count.text = "Trees: %s" % ForestData.tree_count
	cell_count.text = "Cells: %s" % ForestData.cell_count
	if ForestData.cell_count > 0:
		lambda.text = "λ: %.3f" % [float(ForestData.tree_count)/float(ForestData.cell_count)]
	sim_count.text = "No of Sim: %s" % sim_slider.value
	lambda_value.text = "Lambda (λ): %.2f" % lambda_slider.value
	lambda2_value.text = "Lambda λ2: %.2f" % lambda2_slider.value
	
	offspring_value.text = "Children (µ): %.1f" % offspring_slider.value
	radius_value.text = "Radius (R): %.1f" % radius_slider.value
	
func _on_TreeSlider_value_changed(value: float) -> void:
	sim_count.text = "No of Sim: %s" % int(value)

func update_plot() -> void:
	var lambda: = float(ForestData.tree_count)/float(ForestData.cell_count)
	hist.update_plot(ForestData.grid_count,ForestData.tree_count,lambda,is_model)


func _on_ModelButton_button_up() -> void:
	if is_model:
		is_model = false
	else:
		is_model = true
	update_plot()


func _on_LambdaSlider_value_changed(value: float) -> void:
	lambda_value.text = "Lambda (λ): %.2f" % value


func _on_GraphButton_button_up() -> void:
	if is_hist:
		hist.visible = false
		is_hist = false
	else:
		hist.visible = true
		is_hist = true


func _on_Lambda2Slider_value_changed(value: float) -> void:
	lambda2_value.text = "Lambda λ2: %.2f" % value


func _on_OffspringSlider_value_changed(value: float) -> void:
	offspring_value.text = "Children (µ): %.1f" % value


func _on_RadiusSlider_value_changed(value: float) -> void:
	radius_value.text = "Radius (R): %.1f" % value


func _on_L1Button_button_up() -> void:
	get_tree().change_scene("res://src/Levels/Level01.tscn")
	ForestData.cell_count = 0

	
	#get_tree().change_scene(get_tree().current_scene.)
func _on_L2Button_button_up() -> void:
	get_tree().change_scene("res://src/Levels/Level02.tscn")
	ForestData.cell_count = 0

	
func _on_L3Button_button_up() -> void:
	get_tree().change_scene("res://src/Levels/Level03.tscn")
	ForestData.cell_count = 0
	
func _on_L4Button_button_up() -> void:
	get_tree().change_scene("res://src/Levels/Level04.tscn")
	ForestData.cell_count = 0
	
func _on_L5Button_button_up() -> void:
	get_tree().change_scene("res://src/Levels/Level05.tscn")
	ForestData.cell_count = 0
