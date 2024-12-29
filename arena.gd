extends Node2D

var enemy_1 = preload("res://enemy.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.node_creation_parent = self

func _exit_tree() -> void:
	Global.node_creation_parent = null 
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_enemy_spawn_timer_timeout() -> void:
	var enemy_position = Vector2(randf_range(-10, 670), randf_range(-90, 390))
	while enemy_position.x < 640 and enemy_position.x > -10 and enemy_position.y < 360 and enemy_position.y > -45:
		enemy_position = Vector2(randf_range(-10, 670), randf_range(-90, 390))
	#enemy_position.x = -10 if randf() < 0.5 else 670
	var copies = int(randf_range(1,2))
	#var copies = 1
	for i in copies:
		var offset = Vector2(randf_range(-30, 30), randf_range(-20, 20))
		Global.instance_node(enemy_1, enemy_position + offset, self)
