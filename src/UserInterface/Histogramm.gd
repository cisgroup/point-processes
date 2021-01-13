extends MarginContainer

onready var Bar0 = get_node("Canvas/Rows/Bar0") 
onready var Bar1 = get_node("Canvas/Rows/Bar1") 
onready var Bar2 = get_node("Canvas/Rows/Bar2") 
onready var Bar3 = get_node("Canvas/Rows/Bar3") 
onready var Bar4 = get_node("Canvas/Rows/Bar4") 
onready var Bar5 = get_node("Canvas/Rows/Bar5") 
onready var Bar6 = get_node("Canvas/Rows/Bar6")
onready var Label1 = get_node("Canvas/Rows/Labels/Axis2/Label")
onready var Label2 = get_node("Canvas/Rows/Labels/Axis3/Label")
onready var ModelColor = get_node("Canvas/Rows/Legend/ModelColor")
onready var ModelLabel = get_node("Canvas/Rows/Legend/ModelLabel")

var count: = []
var model: = []
var proportion: = []
var bars: = []
var factorial:= {0:1.0,1:1,2:2,3:6,4:24,5:120,6:720,7:5040,8:40320,9:362880}

func _ready() -> void:
	bars = [Bar0,Bar1,Bar2,Bar3,Bar4,Bar5,Bar6]

func update_plot(data:Array,num_of_trees:int,lambda:float,enabled:bool=false) -> void:
	count = [0,0,0,0,0,0,0]
	model = [0,0,0,0,0,0,0]
	
	for x in range(len(data)):
		for y in range(len(data)):
			if data[x][y] <= 6:
				count[data[x][y]] += 1

	var _sum = sum_array_int(count)
	proportion = div_array(count,sum_array_int(count))

	var _max = max_array(proportion)
	
	for i in range(len(model)):
		model[i] = poisson_pmf(i,lambda)
		
	if enabled:
		_max = max(max_array(proportion),max_array(model))

	for i in range(len(proportion)):
		bars[i].set_label(str(i))
		bars[i].set_max(_max)
		bars[i].set_value_data(proportion[i])
		bars[i].set_value_model(model[i])
		if enabled:
			bars[i].set_model_visible()
			ModelColor.visible = true
			ModelLabel.visible = true
		else:
			bars[i].set_model_invisible()
			ModelColor.visible = false
			ModelLabel.visible = false
		
	Label1.text = "%.2f" % [_max/2]
	Label2.text = "%.2f" % [_max]
	
static func sum_array_int(array:Array)->int:
	var sum = 0.0
	for element in array:
		sum += element
	return sum

static func div_array(array:Array,value:float)->Array:
	var div = []
	for element in array:
		div.append(element/value)
	return div

static func min_array(array:Array)->float:
	var min_val = array[0]

	for i in range(1, array.size()):
		min_val = min(min_val, array[i])

	return min_val

static func max_array(array:Array)->float:
	var max_val = array[0]

	for i in range(1, array.size()):
		max_val = max(max_val, array[i])

	return max_val

func poisson_pmf(k:int,lambda:float)->float:
	return pow(lambda, k) * pow(2.718282,-lambda)/factorial[k]
