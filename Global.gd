extends Node

var node_creation_parent = null
var player = null

func instance_node(node, location, parent, velocity = null):
	var node_instance = node.instantiate()
	if (velocity != null):
		node_instance.velocity = velocity
	parent.add_child(node_instance)
	node_instance.global_position = location 
	return node_instance 
