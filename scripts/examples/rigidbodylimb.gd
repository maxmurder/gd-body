# Example rigidbody limb container
# Test implementation takes damage from collissions and allows user to click
# to damage and sever.
extends RigidBody2D

export(NodePath) var body
export(NodePath) var limb
export(NodePath) var joint
export(float) var physicsDamageThreshold = 50.0


onready var _bodynode = get_node(body)
onready var _limbnode = get_node(limb)
var _attach = true

func _ready():
    connect("body_enter", self, "body_enter")
    set_process(true)
    set_process(true)
    pass

func _input_event(viewport, event, shape_idx):
    if event.is_pressed() && _attach:
        if event.type == InputEvent.MOUSE_BUTTON:
            if event.button_index == BUTTON_LEFT:
                _bodynode.damagelimb(_limbnode.get_path(), 1, 0.5)
            if event.button_index == BUTTON_RIGHT:
                _bodynode.severlimb(_limbnode.get_path(), 1)
    pass

func _process(delta):
    if !_limbnode.attached:
        if _attach:
            detachlimb()
            _attach = false
    else:
        for l in _limbnode.layers.keys():
            var f = _limbnode.layers[l]["INTEGRITY"]
            var c = Color(1, f, f)
            for n in get_children():
                if n extends Sprite:
                    n.set_modulate(c)
    pass

func body_enter(body):
    if _attach:
        if body extends RigidBody2D:
            var mag = magnitude((body.get_linear_velocity() - get_linear_velocity()))
            var force = body.get_mass() * mag
            if force > physicsDamageThreshold:
                _bodynode.damagelimb(_limbnode.get_path(), force * 0.01)
        else:
            var mag = magnitude(get_linear_velocity())
            var force = get_mass() * mag
            if force > physicsDamageThreshold:
                _bodynode.damagelimb(_limbnode.get_path(), force * 0.01)
    pass
func magnitude(vec):
    return sqrt(vec.x * vec.x + vec.y * vec.y)

func detachlimb():
    var j = get_node(joint)
    if j != null:
        j.queue_free()
    pass
