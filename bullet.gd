extends Sprite2D

var velocity = Vector2(1,0)
var speed = 250
var acceleration = 0
var lifetime = 0
var maxlife = 4

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	speed += acceleration * delta
	speed = max(speed, 0)
	global_position += velocity.rotated(rotation) * speed * delta
	lifetime += delta
	if lifetime > maxlife or speed <= 0:
		queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
