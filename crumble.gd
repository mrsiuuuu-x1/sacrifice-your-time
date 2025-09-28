extends StaticBody2D

var time = 1

func _ready() -> void:
	set_process(false)
	
func _process(delta: float) -> void:
	time += 1
	$Sprite2D.position += Vector2(0, sin(time) * 2)

func _on_area_2d_body_entered(body: Node2D) -> void:
	set_process(true)
	$Timer.start(0.7)


func _on_timer_timeout() -> void:
	queue_free()
