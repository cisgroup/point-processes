extends HBoxContainer

onready var Number:Label = get_node("Axis/ColorRect/Number") 
onready var BarData:ProgressBar = get_node("Bars/BarData")
onready var BarModel:ProgressBar = get_node("Bars/BarModel")

func test():
	print("hist test bar")

func set_label(value:String) -> void:
	Number.text = value

func set_max(value:float) -> void:
	BarData.max_value = value
	BarModel.max_value = value
	
func set_value_data(value:float) -> void:
	BarData.value = value

func set_value_model(value:float) -> void:
	BarModel.value = value

func set_model_visible() -> void:
	BarModel.visible = true

func set_model_invisible() -> void:
	BarModel.visible = false
