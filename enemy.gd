extends Sprite2D

var hp = 3
var speed = 60
var effective_speed = speed
var stun = false
var velocity = Vector2()

var blood_particles = preload("res://blood_particles.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Global.player != null and stun == false:
		velocity = global_position.direction_to(Global.player.global_position)
		var distance = global_position.distance_to(Global.player.global_position)
		effective_speed = min(speed, distance/4 + 2)
	elif stun:
		velocity = lerp(velocity, Vector2(0,0), 0.3)
		effective_speed = speed * -3
	global_position += velocity * effective_speed * delta

	if hp <= 0:
		if (Global.node_creation_parent != null):
			var blood_inst = Global.instance_node(blood_particles, global_position, Global.node_creation_parent)
			var splatter = velocity * -1
			blood_inst.rotation = splatter.angle()
		queue_free()
		

func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy_damager"):
		modulate = Color.WHITE
		stun = true
		$stun_timer.start()
		area.get_parent().queue_free()
		hp -= 1


func _on_stun_timer_timeout() -> void:
	modulate = Color("91264b")
	stun = false
