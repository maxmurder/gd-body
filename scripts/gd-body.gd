#
#
#
#

extends Node

export(String, FILE) var systemFile = "res://data/systems.json"
export(String, FILE) var flagFile = "res://data/flags.json"

onready var _systemdata = loadjson(systemFile)
onready var _flagdata = loadjson(flagFile)
var _limbs = {}
var _systems = {}

func _ready():
    _limbs = setupbody(self)
    _systems = setupsystems(_limbs)
    pass

#get the data for a system
func getsystem(system):
    if _systems.has(system):
        return _systems[system]
    return false

#generate system data
func setupsystems(limbs):
    if _systemdata == null:
        return
    var dict = {}
    for s in _systemdata:
        var list = []
        for k in limbs.keys():
            for i in limbs[k]["FLAGS"]:
                if _flagdata.has(i) and _flagdata[i].has("SYSTEMS"):
                    for f in _flagdata[i]["SYSTEMS"]:
                        if f == s:
                            if not k in list:
                                list.append(k)
        if list.size() > 0:
            dict[s] = list
    return dict

#generate body data
static func setupbody(node):
    var dict = {}
    for n in node.get_children():
        if n.get_child_count() > 0:
            var d = setupbody(n)
            for k in d.keys():
                dict[k] = {
                    NAME = d[k]["NAME"],
                    SIZE = d[k]["SIZE"],
                    FLAGS = d[k]["FLAGS"],
                    LAYERS = d[k]["LAYERS"]
                }
        dict[n.get_path()] = {
            NAME = n.get_name(),
            SIZE = n.size,
            FLAGS = n.flags,
            LAYERS = n.layers
        }
    return dict

#json loader function
static func loadjson(path):
    var dict = {}
    var file = File.new()
    if path == null:
        return
    if !file.file_exists(path):
        return
    file.open(path, File.READ)
    dict.parse_json(file.get_as_text())
    file.close()
    return dict
