extends Node2D

# Grid Variables
@export var width: int;
@export var height: int;
@export var x_start: int;
@export var y_start: int;
@export var offset: int;

# The piece array
var possible_pieces = [
preload("res://Scenes/yellow_piece.tscn"),
preload("res://Scenes/blue_piece.tscn"),
preload("res://Scenes/green_piece.tscn"),
preload("res://Scenes/light_green_piece.tscn"),
preload("res://Scenes/orange_piece.tscn"),
preload("res://Scenes/pink_piece.tscn")
];

# The current pieces in the scene
var all_pieces = [];

# Touch variables
var first_touch = Vector2(0, 0);
var final_touch = Vector2(0, 0);

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize();
	all_pieces = make_2d_array();
	spawn_pieces();

# Creates our grid in an array based on width and height
func make_2d_array():
	var array = [];
	for i in width:
		array.append([]); 
		for j in height:
			array[i].append(null);
	return array;

# Spawns pieces on the Grid
func spawn_pieces():
	for i in width:
		for j in height:
			# choose random number and store it
			var rand = randi_range(0, possible_pieces.size()-1);
			# instantiate that piece from the array
			var piece = possible_pieces[rand].instantiate();
			var loops = 0;
			while(match_at(i, j, piece.color) && loops < 100):
				rand = randi_range(0, possible_pieces.size()-1);
				loops += 1;
				piece = possible_pieces[rand].instantiate();
			add_child(piece);
			# place piece on board
			piece.set_position(grid_to_pixel(i, j));
			all_pieces[i][j] = piece;

# Checks if there would be a match of 3
func match_at(i, j, color):
	if i > 1:
		if all_pieces[i - 1][j] != null && all_pieces[i - 2][j] != null:
			if all_pieces[i - 1][j].color == color && all_pieces[i - 2][j].color == color:
				return true;
	if j > 1:
		if all_pieces[i][j - 1] != null && all_pieces[i][j - 2] != null:
			if all_pieces[i][j - 1].color == color && all_pieces[i][j - 2].color == color:
				return true;
	pass;

# Helper function that converts our grid position to pixel position
func grid_to_pixel(column, row):
	var new_x = x_start + offset * column;
	var new_y = y_start + -offset * row;
	return Vector2(new_x, new_y);

# Helper function that converts our pixel position to grid position
func pixel_to_grid(pixel_x, pixel_y):
	var new_x = round((pixel_x - x_start) / offset);
	var new_y = round((pixel_y - y_start) / -offset);
	return Vector2(new_x, new_y);

func touch_input():
	# Registers us touching the screen
	if Input.is_action_just_pressed("ui_touch"):
		first_touch = get_global_mouse_position();
		# Convert Pixel coords to Grid coords
		var grid_position = pixel_to_grid(first_touch.x, final_touch.y);
		print(grid_position);
	# Registers us picking up from the screen
	if Input.is_action_just_released("ui_touch"):
		final_touch = get_global_mouse_position();

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	touch_input();
