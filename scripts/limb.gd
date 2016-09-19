extends Node

export(float, 0.0, 1.0, 0.01) var size = 1.0
export var material_layers = StringArray()
export var flags = StringArray()
onready var layers = processlayers(material_layers)
var attached = true

static func processlayers(materials):
    var dict = {}
    for i in range(materials.size()):
        dict[materials[i]] = { LAYER = i, INTEGRITY = 1.0, DAMAGE = 0.0}
    return dict
