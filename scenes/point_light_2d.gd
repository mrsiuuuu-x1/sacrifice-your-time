extends PointLight2D

func _ready():
	var size = 256
	var image = Image.create(size, size, false, Image.FORMAT_RGBA8)
	var center = Vector2(size / 2.0, size / 2.0)
	var radius = size / 2.0

	for x in range(size):
		for y in range(size):
			var dist = Vector2(x, y).distance_to(center)
			var alpha = clamp(1.0 - (dist / radius), 0.0, 1.0)
			alpha = alpha * alpha
			image.set_pixel(x, y, Color(1, 1, 1, alpha))

	var tex = ImageTexture.create_from_image(image)
	texture = tex
	texture_scale = 3.0