extends KinematicBody2D

export(NodePath) var body
export(NodePath) var limb
onready var _bodynode = get_node(body)
onready var _limbnode = get_node(limb)

func _ready():
    set_process_input(true)
    set_process(true)
    pass

func _input_event(viewport, event, shape_idx):
    if event.is_pressed():
        if event.type == InputEvent.MOUSE_BUTTON:
            if event.button_index == BUTTON_LEFT:
                _bodynode.damagelimb(_limbnode.get_path(), 1, 0.5)
            if event.button_index == BUTTON_RIGHT:
                _bodynode.severlimb(_limbnode.get_path(), 1)
    pass

func _process(delta):
    if !_limbnode.attached:
        hide()
        set_process(false)
    pass
