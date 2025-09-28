extends AnimationPlayer

var gate_open = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if gate_open == false:
		if Input.is_action_just_pressed("start"):
			play("move_gate")
			gate_open = true
