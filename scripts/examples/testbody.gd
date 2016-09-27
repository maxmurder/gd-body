# Test controller for livingbody.
extends "res://scripts/livingbody.gd"

func _ready():
    set_process_unhandled_input(true)

func _unhandled_input(ev):
    if ev.type == InputEvent.MOUSE_BUTTON:
        if ev.is_pressed():
            randomize()
            var i = randi() % _limbs.keys().size()
            print(_limbs.keys()[i])
            if ev.button_index == BUTTON_LEFT:
                damagelimb(_limbs.keys()[i], 0.5, 0.5)
            if ev.button_index == BUTTON_RIGHT:
                severlimb(_limbs.keys()[i], 0.5)
    pass
