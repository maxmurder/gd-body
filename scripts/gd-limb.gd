# gd-limb.gd
# Limb container class. gd-body.gd will take the information from this class in
# its body generation. This class can also be used to store staus information
# about individual limbs.
 
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
