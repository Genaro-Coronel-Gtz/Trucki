extends Node

@onready var current_animation: AnimatedSprite2D = null
@onready var truck_animated = $"../AnimatedSprite2D"
@onready var truck_box_anim = $"../TruckBox"

enum State {
	IDLE,
	DRIVE,
	SINGLE,
	BOX
}

var current_state: State = State.IDLE

func change_state(new_state: State):
	if current_state == new_state:
		return
		
	current_state = new_state
	match current_state:
		State.SINGLE:
			truck_box_anim.hide()
			truck_animated.show()
			current_animation = truck_animated
		State.BOX:
			truck_box_anim.show()
			truck_animated.hide()
			current_animation = truck_box_anim
		State.IDLE:
			current_animation.play("idle")
		State.DRIVE:
			current_animation.play("drive")
