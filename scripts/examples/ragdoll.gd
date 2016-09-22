
extends RigidBody2D

export(NodePath) var joint

func _ready():
    set_process_unhandled_input(true)

func _unhandled_input(ev):
    if ev.type == InputEvent.MOUSE_BUTTON:
        if ev.is_pressed():
            if ev.button_index == BUTTON_LEFT:
                var n = get_node(joint)
                n.queue_free()
    pass
