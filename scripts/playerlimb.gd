extends KinematicBody2D

export(NodePath) var body
export(NodePath) var limb
export(Vector2) var length = Vector2(0, 16)
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
            var l = generateragdoll(self)
            l.set_pos(get_global_pos())
            l.set_rot(get_rot())
            _attach = false
        deactivate(self)
        hide()
        set_process(false)
    pass

func generateragdoll(lmb, parent = null):
    var obj = RigidBody2D.new()
    for i in range(lmb.get_shape_count()):
        obj.add_shape(lmb.get_shape(i), lmb.get_shape_transform(i))
    if parent != null:
        parent.add_child(obj)
        obj.set_pos(lmb.get_pos())
        obj.set_rot(lmb.get_rot())
        var j = PinJoint2D.new()
        obj.add_child(j)
        #j.set_pos(lmb.length)
        j.set_node_a(parent.get_path())
        j.set_node_b(obj.get_path())
    else:
        get_tree().get_root().add_child(obj)
    for n in lmb.get_children():
        if n extends Sprite:
            var i = n.duplicate(true)
            obj.add_child(i)
        if n extends get_script():
            if n._attach:
                var i = generateragdoll(n, obj)
                n._attach = false
    return obj

func deactivate(lmb):
    lmb.set_layer_mask(0)
    lmb.set_collision_mask(0)
    for f in lmb.get_children():
        if f extends get_script():
            deactivate(f)
    pass
