
extends Node2D

export(NodePath) var body
export(NodePath) var anim
export(float) var movespeed = 1.0
onready var _anim = get_node(anim)
var bodynode

func _ready():
    set_process(true)
    _anim.play("test")
    #set_process_input(true)
    bodynode = get_node(body)
    pass

func _process(delta):
    if bodynode.checksystem("LOCOMOTION"):
        move(delta)
    if !bodynode.checksystem("MOTOR"):
        _anim.stop()
    pass

func move(delta):
    var i = 0
    var n = 0
    for l in bodynode.getsystem("LOCOMOTION"):
        var node = get_node(l)
        if bodynode.checklimb(node):
            n += 1
        i += 1
    var velocity = Vector2(0.0,0.0)
    if Input.is_action_pressed("move_down"):
        velocity.y += movespeed
    if Input.is_action_pressed("move_up"):
        velocity.y -= movespeed
    if Input.is_action_pressed("move_right"):
        velocity.x += movespeed
    if Input.is_action_pressed("move_left"):
        velocity.x -= movespeed
    translate(velocity * (float(n) / float(i)) * delta)
    pass
