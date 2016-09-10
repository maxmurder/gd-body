
extends Node

export(String, FILE) var materialsFile
export(String, FILE) var systemFile

onready var _materialdata = loadjson(materialsFile)
onready var _systemdata = loadjson(systemFile)
var _limblist = []
var _systems = {}

func _ready():
    _limblist = processbody(self)
    _systems = processsystems(_limblist, _systemdata)
    print(checkstatus(_systems["VITAL"], 1.0))
    pass

func _process(delta):
    print(checkstatus(_systems["VITAL"], 1.0))
    pass

func checkstatus(system, threshold, type = "INTEGRITY", material = "NONE"):
    for i in system:
        var node = get_node(i)
        if material == "NONE":
            for l in node.limb_layers:
                if node.limb_layers[l][type] < threshold:
                    return false
        else:
            if node.limb_layers.has(material):
                if node.limb_layers[material][type] < threshold:
                    return false
                else:
                    return checkstatus(system, threshold)
    return true

static func processbody(node):
    var list = []
    for n in node.get_children():
        if n.get_child_count() > 0:
            for l in processbody(n):
                list.append(l)
        list.append(n)
    return list

static func processsystems(limblist, systemlist):
    var dict = {}
    for s in systemlist:
        var list = []
        for l in limblist:
            for i in l.limb_flags:
                if s == i:
                    list.append(l.get_path())
        if list.size() > 0:
            dict[s] = list
    return dict

static func loadjson(path):
    var dict = {}
    var file = File.new()
    if !file.file_exists(path):
        return
    file.open(path, File.READ)
    dict.parse_json(file.get_as_text())
    file.close()
    return dict
