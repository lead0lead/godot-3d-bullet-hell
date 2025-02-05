extends Node

class_name State

var player: CharacterBody3D

var animation: String
var state_name: String

var enter_state_time: float

static var state_priority: Dictionary = {
	"idle": 1,
	"idle_jump_start": 10,
	"idle_jump_midair": 10,
	"idle_jump_landing": 10,
	"run": 2,
	"running_jump_start": 10,
	"running_jump_midair": 10,
	"running_jump_landing": 10,
	"boosting": 15,
}

static func state_priority_sort(a: String, b: String):
	if state_priority[a] > state_priority[b]:
		return true
	else: return false


func check_relevance(Input: InputPackage) -> String:
	print_debug("error, ímplement the check_relevance function on your state")
	return "error, ímplement the check_relevance function on your state"


func update(input: InputPackage, delta: float):
	pass


func on_enter_state():
	print(state_name)
	pass


func on_exit_state():
	pass


func mark_enter_state():
	enter_state_time = Time.get_unix_time_from_system()
	
func get_progress() -> float:
	var now = Time.get_unix_time_from_system()
	return now - enter_state_time

func works_longer_than(time: float) -> bool:
	if get_progress() >= time:
		return true
	return false

func works_less_than(time: float) -> bool:
	if get_progress() < time:
		return true
	return false

func works_between(start: float, finish: float) -> bool:
	var progress = get_progress()
	if progress >= start and progress <= finish:
		return true
	return false
