
extends Node

var limblist = []

func _ready():
    processbody(self)
    for l in limblist:
        print(l.size)
    pass

func processbody(node):
    for n in node.get_children():
        if n.get_child_count() > 0:
            processbody(n)
        limblist.append(n)
    pass
