extends "res://scripts/body.gd"

export(float) var systemThreshold = 0.5
export(float) var vitalThresholdIntegrity = 1.0
export(float) var vitalThresholdDamage = 0.0

func _ready():
    set_process(true)
    set_process_unhandled_input(true)
    pass

func _process(delta):
    for i in _systems.keys():
        var s = "%s : %s"
        print(s % [i,checkstatus(_systems[i])])
    pass

func _unhandled_input(ev):
    if ev.type == InputEvent.MOUSE_BUTTON:
        if ev.is_pressed():
            var i = randi() % _limbs.keys().size()
            print(_limbs.keys()[i])
            severlimb(_limbs.keys()[i])
    pass

func severlimb(limb):
    var node = get_node(limb)
    var parent = node.get_parent()
    node.detach()
    #parent.damage()
    pass

func checkstatus(system):
    for n in system:
        var node = get_node(n)
        if "VITAL" in node.flags:
            for l in node.layers:
                if node.layers[l]["INTEGRITY"] < vitalThresholdIntegrity or node.layers[l]["DAMAGE"] > vitalThresholdDamage:
                    return false
                if !node.attached:
                    return false
        else:
            for l in node.layers:
                if node.layers[l]["INTEGRITY"] > systemThreshold:
                    return true
                if node.attached:
                    return true
            return false
    return true
