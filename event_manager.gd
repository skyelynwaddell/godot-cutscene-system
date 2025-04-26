extends Node

## Event Manager System by Skye Waddell
## sorry this is the best cutscene system i could make

var event_playing := false ## true / false if a cutscene/event is active

var no_event : Callable = func(_delta):pass ## default event function when none is happening
var current_event := no_event ## The Cutscene event that should be played
var current_action := 1 ## the current action in the cutscene/event
var timer := 0.0 ## timer for waits


## Returns TRUE/FALSE if a cutscene/event is currently playing
func IsEventPlaying(): return event_playing

## Process step event
func _process(delta: float) -> void:
	if event_playing:
		current_event.call(delta)


## Call this from other objects/scenes to create a new event/cutscene
func EventCreate(event_callback : Callable):
	## Callback format example : 
	#var event_callback = func(_delta):
			#match(EventManager.current_action):
				#1: EventManager.EventStart()
				#2: EventManager.EventWait(3.0, delta)
				#3: EventManager.EventSayHello()
				#4: EventManager.EventEnd()
				
	if event_playing: return ## Prevent multiple events from happening at the same time
	
	current_action = 1 ## Reset the current action index to start from beginning of event orderly
	current_event = event_callback
	event_playing = true


## When already in a cutscene.... Say an NPC asks a question and you respond YES or NO.
## This lets you create a new event from another seperate callback
## This is how you could have branching dialogue
## So say you create event with list of actions from Callback #1, then if you reply YES, you get another event of actions from Callback #2, etc etc.....
## DOES THIS CLUCKING MAKE SENSE?! I HOPE SO
func EventCreateAnother(event_callback : Callable):
	event_playing = false ## Stop current event
	#Signals.DialogueEnd.emit() ## Close any open dialogues ## i close any open dialogue in my game
	EventCreate(event_callback) ## Create the new event from the next callback of actions provided


## Starts an Ordered Event
func EventStart(): 
	print("Event Starting")
	#Signals.PlayerFreeze.emit() maybe you want to freeze the player here
	EventNext()


## Called when an event/cutscene has finished all its functions/actions
func EventEnd():
	print("Event Ending")
	current_event = no_event
	#Signals.PlayerUnfreeze.emit() maybe you want to unfreeze the player here
	event_playing = false
	current_action = 1


## Once an action in an event completes, call this to move to the next action in the event
func EventNext():
	print("Next Action")
	current_action += 1


## Event Action to wait for a speicified time in seconds
func EventWait(time:float, delta:float):
	timer += delta
	if timer >= time: 
		timer = 0.0
		EventNext()
	

## Event Action to print a console log statement
func EventPrint(text:String):
	print(text)
	EventNext()


## Event action to change the facing direction of a player or npc
func EventChangeCharacterFacingDirection(player:CharacterBody2D, face_towards:String):
	if face_towards == "LEFT":
		player.FaceLeft()
	else:
		player.FaceRight()
	
	EventNext()


## Example Cutscene / Event
#func event_test(delta:float):
	#match(current_action):
		#1 : EventStart()
		#2 : EventWait(5.0, delta)
		#3 : EventSayHello()
		#4 : EventWait(2.0, delta)
		#5 : EventEnd()
	
