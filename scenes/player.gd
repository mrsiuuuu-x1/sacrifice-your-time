extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const MAX_FALL_SPEED = 1000.0
const DASH_SPEED = 800.0
const DASH_DURATION = 0.2
const DASH_COOLDOWN = 1.0

var waken_up = false
var windy_zone = false
var WIND_FORCE = -6000

var jump_count = 0
var has_double_jump = true

# Dash state
var is_dashing = false
var dash_timer = 0.0
var dash_cooldown_timer = 0.0
var dash_direction = 0

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	animated_sprite_2d.play("wakeup")

func _on_animated_sprite_2d_animation_finished() -> void:
	waken_up = true

func _physics_process(delta: float) -> void:
	# Update dash cooldown
	if dash_cooldown_timer > 0:
		dash_cooldown_timer -= delta

	# Update dash timer
	if is_dashing:
		dash_timer -= delta
		if dash_timer <= 0:
			is_dashing = false

	# Apply gravity when not dashing
	if not is_on_floor() and not is_dashing:
		velocity.y += get_gravity().y * delta
		velocity.y = min(velocity.y, MAX_FALL_SPEED)
	elif is_on_floor():
		jump_count = 0

	if waken_up:
		var direction := Input.get_axis("left", "right")

		# --- DASH ---
		if Input.is_action_just_pressed("dash") and dash_cooldown_timer <= 0 and direction != 0:
			is_dashing = true
			dash_timer = DASH_DURATION
			dash_cooldown_timer = DASH_COOLDOWN
			dash_direction = direction
			velocity.y = 0  # Optional: cancel vertical movement

		# --- JUMPING ---
		if not is_dashing and Input.is_action_just_pressed("jump"):
			if is_on_floor():
				velocity.y = JUMP_VELOCITY
				jump_count = 1
			elif has_double_jump and jump_count == 1:
				velocity.y = JUMP_VELOCITY
				jump_count = 2

		# --- MOVEMENT ---
		if is_dashing:
			velocity.x = dash_direction * DASH_SPEED
		elif direction:
			velocity.x = direction * SPEED
			animated_sprite_2d.flip_h = direction < 0
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

		# --- WIND ZONE ---
		if windy_zone and not is_dashing:
			velocity.x += WIND_FORCE * delta

		# --- ANIMATIONS ---
		if is_dashing:
			animated_sprite_2d.play("run") # Make sure you have a dash animation
		elif not is_on_floor():
			animated_sprite_2d.play("jump")
		elif direction == 0:
			animated_sprite_2d.play("idle")
		else:
			animated_sprite_2d.play("run")

	move_and_slide()

func _on_windy_body_entered(body: Node2D) -> void:
	windy_zone = true

func _on_windy_body_exited(body: Node2D) -> void:
	windy_zone = false
