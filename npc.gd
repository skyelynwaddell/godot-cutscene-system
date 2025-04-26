extends CharacterBody2D
class_name NPC

@export var one_shot : bool = false
var completed : bool = false

## Changes the NPC facing direction
func FaceLeft(): %Sprites.scale.x = -1.0
func FaceRight(): %Sprites.scale.x = 1.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if Input.is_action_just_pressed("interact"):
		EventManager.EventCreate(TestEvent)


## First Event
func TestEvent(delta):
	match(EventManager.current_action):
		1: EventManager.EventStart()
		2: EventManager.EventPrint("Hey there. You must be JOE.")
		3: EventManager.EventPrint("My name is BOB. I hope to see you around...")
		4: EventManager.EventCreateAnother(TestEvent2)
		5: EventManager.EventEnd()


## Second event
func TestEvent2(delta):
	match(EventManager.current_action):
		1 : EventManager.EventStart()
		2 : EventManager.EventDialogueCreate("So you created another branching dialogue!")
		3 : EventManager.EventMoveObject(self, $"../MovePoint", delta)
		4 : EventManager.EventEnd()
