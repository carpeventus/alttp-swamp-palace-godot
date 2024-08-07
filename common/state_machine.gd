class_name StateMachine extends Node

@export var init_state: State

@export var debug: bool = false

var state_map: Dictionary = {}

var current_state: State

func init_state_machine() -> void:
	var nodes: Array[Node] = get_children()
	for node: Node in nodes:
		if node is State:
			state_map[node.name] = node
	apply_init_state(init_state)
	
func apply_init_state(state: State) -> void:
	current_state = state
	current_state.on_enter()
	
func change_state(next_state_name: String) -> void:
	var next: State = state_map[next_state_name]
	if not next:
		return
	# 不允许重复进入
	if next.name == current_state.name:
		return
	
	current_state.on_exit()
	next.on_enter()
	if debug:
		var content: String = "[Time: {time} ms] {cur} -> {next}".format({"time": Time.get_ticks_msec(), "cur": current_state.name, "next":next_state_name})
		print(content)
	current_state = next
