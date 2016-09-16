extends "res://scripts/body.gd"

export(float) var systemThreshold = 0.5
export(float) var vitalThresholdIntegrity = 1.0
export(float) var vitalThresholdDamage = 0.0

var _status = {}
const _limbscript = preload("res://scripts/limb.gd")

func _ready():
    set_process(true)
    set_process_unhandled_input(true)
    for s in _systems:
        _status[s] = checkstatus(s)
    pass

func _process(delta):
    for s in _status.keys():
        _status[s] = checkstatus(s);
    pass

func _unhandled_input(ev):
    if ev.type == InputEvent.MOUSE_BUTTON:
        if ev.is_pressed():
            randomize()
            var i = randi() % _limbs.keys().size()
            print(_limbs.keys()[i])
            severlimb(_limbs.keys()[i])
    pass

func severlimb(limb):
    var node = get_node(limb)
    var parent = node.get_parent()
    if node extends _limbscript:
        node.detach()
    if parent extends _limbscript:
        parent.damage(0.5)
    pass

#checks status of system and its dependencies
func checksystem(system):
    if !_status.has(system):
        return false
    if _status[system] == false:
        return false
    for s in _systemdata[system]["DEPENDS"]:
        if !_status.has(s):
            return false
        if _status[s] == false:
            return false
    return true

#checks status of individual limbs in a system
func checkstatus(system):
    var sys = getsystem(system)
    if sys == false:
        return false
    var status = false
    var vital = true
    for n in sys:
        var node = get_node(n)
        if "VITAL" in node.flags:
            if !node.attached:
                vital = false
            for l in node.layers:
                if node.layers[l]["INTEGRITY"] < vitalThresholdIntegrity or node.layers[l]["DAMAGE"] > vitalThresholdDamage:
                    vital = false
        if node.attached:
            for l in node.layers:
                if node.layers[l]["INTEGRITY"] > systemThreshold:
                    status = true
    return status && vital
