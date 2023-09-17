extends Node2D

# Grid Variables
@export var width: int;
@export var height: int;
@export var x_start: int;
@export var y_start: int;
@export var offset: int;

var all_pieces = [];

# Called when the node enters the scene tree for the first time.
func _ready():
	all_pieces = make_2d_array();
	print(all_pieces);

func make_2d_array():
	var array = [];
	for i in width:
		array.append([]); 
		for j in height:
			array[i].append(null);
	return array;

# Called every frame. 'delta' is the elapsed time since the previous frame.
# func _process(delta):
#	pass
