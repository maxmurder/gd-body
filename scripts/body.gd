
extends Node

var _limblist = []
var _materials

func _ready():
    processbody(self)
    _materials = loadjson("res://materials.json")
    for l in _limblist:
        print(l.size)
    print(_materials["MUSCLE"].values())
    pass

func loadjson(path):
    var dict = {}
    var file = File.new()
    if !file.file_exists(path):
        return
    file.open(path, File.READ)
    dict.parse_json(file.get_as_text())
    file.close()
    return dict

func processbody(node):
    for n in node.get_children():
        if n.get_child_count() > 0:
            processbody(n)
        _limblist.append(n)
    pass
