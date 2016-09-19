extends Node

export(float, 0.0, 1.0, 0.01) var size = 1.0
export var material_layers = StringArray()
export var flags = StringArray()
onready var layers = processlayers(material_layers)
var attached = true

func detach():
    attached = false
    for n in self.get_children():
        n.detach()

#func damage(damage):
#    for l in layers.keys():
#        layers[l]["INTEGRITY"] = layers[l]["INTEGRITY"] - damage / ( layers[l]["LAYER"] + material_layers[l]["hardness"] )
#        layers[l]["DAMAGE"] = layers[l]["DAMAGE"] + damage / ( layers[l]["LAYER"] + material_layers[layers[l]]["hardness"] )
#    pass

static func processlayers(materials):
    var dict = {}
    for i in range(materials.size()):
        dict[materials[i]] = { LAYER = i, INTEGRITY = 1.0, DAMAGE = 0.0}
    return dict
