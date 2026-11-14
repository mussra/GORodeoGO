class_name JumpMemory207
extends RefCounted
const GOAL:int=6
var sequence:Array[int]=[]
var cursor:int=0
var state:String="ready"
var rng:=RandomNumberGenerator.new()
func _init(seed_value:int=0):
 if seed_value==0:rng.randomize()
 else:rng.seed=seed_value
func next_round()->void:
 sequence.append(rng.randi_range(0,3));cursor=0;state="show"
func repeat()->void:cursor=0;state="show"
func begin_input()->void:cursor=0;state="ride"
func land(obstacle:int)->String:
 if state!="ride":return state
 if obstacle!=sequence[cursor]:state="failed";return state
 cursor+=1
 if cursor==sequence.size():state="won" if sequence.size()>=GOAL else "passed"
 return state
