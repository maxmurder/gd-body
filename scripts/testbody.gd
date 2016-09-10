extends "res://scripts/body.gd"

func _ready():
    print(checkstatus(_systems["SENSORY"], 1.0, "NERVOUS"))
    pass

func checkstatus(system, threshold, material = "NONE", type = "INTEGRITY"):
    for i in system:
        var node = get_node(i)
        if material == "NONE":
            for l in node.layers:
                if node.layers[l][type] < threshold:
                    return false
        else:
            if node.layers.has(material):
                if node.layers[material][type] < threshold:
                    return false
                else:
                    return checkstatus(system, threshold)
    return true
