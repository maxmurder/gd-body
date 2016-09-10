extends Node

export var size = 1.0
export var material_layers = StringArray()
export var limb_flags = StringArray()
onready var limb_layers = processlayers(material_layers)

static func processlayers(materials):
    var dict = {}
    for i in range(materials.size()):
        dict[materials[i]] = { LAYER = i, INTEGRITY = 1.0, DAMAGE = 0.0}
    return dict
