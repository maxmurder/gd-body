
extends Node2D

export(NodePath) var body
export(float) var movespeed = 1.0

var bodynode

func _ready():
    set_process(true)
    set_process_unhandled_input(true)
    bodynode = get_node(body)
    pass

func _process(delta):
    if bodynode.checksystem("LOCOMOTION"):
        move(delta)
    pass

func move(delta):
    var velocity = Vector2(0,0)
    if Input.is_action_pressed("move_down"):
        velocity.y += movespeed
    if Input.is_action_pressed("move_up"):
        velocity.y -= movespeed
    if Input.is_action_pressed("move_right"):
        velocity.x += movespeed
    if Input.is_action_pressed("move_left"):
        velocity.x -= movespeed
    self.translate(velocity * delta)
    pass

func _unhandled_input(ev):
    if ev.type == InputEvent.MOUSE_BUTTON:
        if ev.is_pressed():
            randomize()
            var i = randi() % bodynode._limbs.keys().size()
            print(bodynode._limbs.keys()[i])
            if ev.button_index == BUTTON_LEFT:
                bodynode.damagelimb(bodynode._limbs.keys()[i], 0.5, 0.5)
            if ev.button_index == BUTTON_RIGHT:
                bodynode.severlimb(bodynode._limbs.keys()[i], 0.5)
    pass
