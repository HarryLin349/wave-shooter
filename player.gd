extends Sprite2D

var maxHP = 3
var HP = 3

var max_speed = 160
var current_speed = 0

var acceleration_time = 0.25  # Time to reach max speed
var acceleration = max_speed / acceleration_time  # Acceleration value
var velocity = Vector2()

var dash_direction = Vector2()
var dash_speed = 450
var can_dash = true
var is_dashing = false

var can_shoot = true

var bullet = preload("res://bullet.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.player = self
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_dashing:
		perform_dash(delta)
	else:
		move(delta)
	shoot(delta)
	
	if Input.is_action_just_pressed("dash") and can_dash:
		start_dash()
	pass

func shoot_bullet(direction: Vector2) -> void:
	Global.instance_node(bullet, global_position, Global.node_creation_parent, direction)
	can_shoot = false

func shoot(delta: float) -> void:
	var input = Input.get_vector("shoot_left", "shoot_right", "shoot_up", "shoot_down").normalized()
	if input != Vector2.ZERO and can_shoot:
		var rand_velocity = randf_range(0.5,1.2)
		var rand_angle = randf_range(-0.25,0.25)
		var bullet_velocity = (input + velocity * current_speed / max_speed * 0.3) * rand_velocity
		shoot_bullet(bullet_velocity.rotated(rand_angle))


func move(delta: float) -> void:
	var input = Input.get_vector("move_left", "move_right", "move_up", "move_down").normalized()
	if input != Vector2.ZERO:
		# Gradually increase speed to max speed
		current_speed = min(current_speed + acceleration * delta, max_speed)
		# Set velocity direction to the input
		velocity = input
	else:
		# Gradually reduce speed to 0
		current_speed = max(current_speed - 2 * acceleration * delta, 0)
		# Maintain velocity direction while stopping
		velocity = velocity.normalized()
	global_position += velocity * current_speed * delta
	pass


func _on_reload_speed_timeout() -> void:
	can_shoot = true


func _exit_tree() -> void:
	Global.player = null

func start_dash() -> void:
	print("DASH")
	can_dash = false
	is_dashing = true
	dash_direction = velocity.normalized()
	shoot_dash()
	# Temporarily set speed for the dash
	$"Dash Duration".start()
	$"Dash Cooldown".start()
	
func shoot_dash() -> void:
	var copies = 3
	for i in copies:
		var random_angle = randf_range(-0.5, 0.5)
		var bullet = Global.instance_node(bullet, global_position, Global.node_creation_parent)
		bullet.maxlife = 4
		bullet.acceleration = -600
		bullet.speed = randf_range(200,300)
		bullet.scale = Vector2(0.15, 0.15)
		bullet.modulate = Color.SLATE_GRAY
		bullet.velocity = -1 * velocity.rotated(random_angle)

func perform_dash(delta: float) -> void:
	current_speed = lerp(dash_speed, max_speed, 0.1)
	global_position += dash_direction * current_speed * delta

func _on_dash_speed_timeout() -> void:
	is_dashing = false
	pass # Replace with function body.


func _on_dash_cooldown_timeout() -> void:
	can_dash = true
