extends Area2D

@export var zoom_out = Vector2(0.5, 0.5)
@export var zoom_normal = Vector2(1.0, 1.0)
@export var zoom_speed = 2.0

var camera: Camera2D
var player: CharacterBody2D
var is_zoomed_out = false

func _ready():
	await get_tree().process_frame
	camera = get_tree().get_first_node_in_group("camera")
	player = get_tree().get_first_node_in_group("player")
	print("Camera: ", camera)
	print("Player: ", player)

func _process(_delta):
	if camera == null or player == null:
		return
	
	var shape = $CollisionShape2D.shape
	var rect = Rect2(global_position - shape.size / 2, shape.size)
	
	if rect.has_point(player.global_position):
		if not is_zoomed_out:
			is_zoomed_out = true
			print("Player inside zone!")
			create_tween().tween_property(camera, "zoom", zoom_out, zoom_speed)
	else:
		if is_zoomed_out:
			is_zoomed_out = false
			create_tween().tween_property(camera, "zoom", zoom_normal, zoom_speed)
