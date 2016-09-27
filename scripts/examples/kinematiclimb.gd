# Example kinematic limb container
# Test implementation allows user to left click on a limb to apply damage and
# right click on a limb to sever.

extends KinematicBody2D

export(NodePath) var body
export(NodePath) var limb
onready var _bodynode = get_node(body)
onready var _limbnode = get_node(limb)
var _attach = true

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
        if _attach:
            var l = generatechunk(self)
            l.set_pos(get_global_pos())
            l.set_rot(get_rot())
            _attach = false
        deactivate(self)
        hide()
        set_process(false)
    else:
        for l in _limbnode.layers.keys():
            var f = _limbnode.layers[l]["INTEGRITY"]
            var c = Color(1, f, f)
            for n in get_children():
                if n extends Sprite:
                    n.set_modulate(c)
    pass

#generates severed limb chunks
func generatechunk(lmb):
    var obj = RigidBody2D.new()
    obj.set_pos(lmb.get_global_pos())
    obj.set_rot(lmb.get_rot())
    for i in range(lmb.get_shape_count()):
        obj.add_shape(lmb.get_shape(i), lmb.get_shape_transform(i))
    get_tree().get_root().add_child(obj)
    for n in lmb.get_children():
        if n extends Sprite:
            var i = n.duplicate(true)
            obj.add_child(i)
        if n extends get_script():
            if n._attach:
                var i = generatechunk(n)
                n._attach = false
    return obj

#deativates the limb
func deactivate(lmb):
    lmb.set_layer_mask(0)
    lmb.set_collision_mask(0)
    for f in lmb.get_children():
        if f extends get_script():
            deactivate(f)
    pass
