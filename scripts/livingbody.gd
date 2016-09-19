extends "res://scripts/body.gd"

export(String, FILE) var materialFile
export(float) var systemThreshold = 0.5
export(float) var vitalThresholdIntegrity = 0.5
export(float) var vitalThresholdDamage = 0.25
export(float) var vesselBleedRate = 0.5
export(float) var arteryBleedRate = 5.0

var _status = {}
var _circsystem = {}
var _blood = 1000.0
const _limbscript = preload("res://scripts/limb.gd")
onready var _materaldata = loadjson(materialFile)

func _ready():
    set_process(true)
    for s in _systems:
        _status[s] = checkstatus(s)
    _circsystem = getsystem("CIRCULATION")
    pass

func _process(delta):
    for s in _status.keys():
        _status[s] = checkstatus(s);
    pass

#do damage to a limb
#falloff is the multiplier on the damage done to immidate children marked internal
#child damamge is a chance based on relative size
func damagelimb(limb, damage, falloff):
    var node = get_node(limb)
    if node extends _limbscript:
        damage(node, damage)
        for n in node.get_children():
            if n extends _limbscript:
                for f in n.flags:
                    if f == "INTERNAL":
                        randomize()
                        if randi() % 100 > 100 * abs(node.size - n.size):
                            print(n.get_path())
                            damage(n, damage * falloff)
                        break
    pass

#sever a limb, and do damage to it
func severlimb(limb, damage):
    var node = get_node(limb)
    var parent = node.get_parent()
    if node extends _limbscript:
        node.detach()
    if parent extends _limbscript:
        parent.damage(damage)
    pass

#applies damage to a limb
func damage(limb, damage):
    var layers = limb.layers;
    for l in layers.keys():
        var d = damage
        if _materaldata.has(l):
            d =  damage / ( layers[l]["LAYER"] + _materaldata[l]["hardness"] )
        layers[l]["INTEGRITY"] = layers[l]["INTEGRITY"] - d
        layers[l]["DAMAGE"] = layers[l]["DAMAGE"] + d
    limb.layers = layers
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

#checks status of all limbs in a system
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

func processcirc(delta):
    for l in _circsystem:
        var node = get_node(l)
    pass
