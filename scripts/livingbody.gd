extends "res://scripts/body.gd"

export(String, FILE) var materialFile = "res://data/materials.json"
export(float) var systemThreshold = 0.5 #integrity/damage threshold for regular system components
export(float) var vitalThresholdIntegrity = 0.5 #integrity threshold for vital components
export(float) var vitalThresholdDamage = 0.25 #damage threshold for vital components
export(float) var vesselBleedRate = 10.0 #bleed rate for VASCULAR materials
export(float) var arteryBleedRate = 500.0 #bleed rate for ARTEREAL materials
export(float) var vesselHealRate = 1.0 #heal rate for VASCULAR materials
export(float) var blood = 1000.0 #amount of blood
export(float) var bleedOutThreshHold = 500.0 #threshold for bleed out
export(float) var structureDetachThreshold = 0.1 #STRUCTURE material integrity threshold for limb detact

var _status = {}
const _limbscript = preload("res://scripts/limb.gd")
onready var _materialdata = loadjson(materialFile)

func _ready():
    set_process(true)
    for s in _systems:
        _status[s] = checkstatus(s)
    pass

#do damage to a limb
#falloff is the multiplier on the damage done to immidate children marked internal
#child damamge is a chance based on relative size
func damagelimb(limb, damage, falloff = 0):
    if damage <= 0:
        return
    var node = get_node(limb)
    if node extends _limbscript:
        applydamage(node, damage)
        if falloff <= 0:
            return
        for n in node.get_children():
            if n extends _limbscript:
                for f in n.flags:
                    if f == "INTERNAL":
                        randomize()
                        if randi() % 100 > 100 * abs(node.size - n.size):
                            print(n.get_path())
                            applydamage(n, damage * falloff)
                        break
    pass

#sever a limb, and do damage to the parent
func severlimb(limb, damage = 0, falloff = 0):
    var node = get_node(limb)
    var parent = node.get_parent()
    if node extends _limbscript:
        detachlimb(node)
    if parent extends _limbscript:
        damagelimb(parent.get_path(), damage, falloff)
    pass

#applies damage to a limb
func applydamage(limb, damage):
    var layers = limb.layers;
    for l in layers.keys():
        var d = damage
        if _materialdata.has(l):
            d =  damage / ( layers[l]["LAYER"] + _materialdata[l]["hardness"] )
        layers[l]["INTEGRITY"] = max(layers[l]["INTEGRITY"] - d, 0)
        layers[l]["DAMAGE"] = min(layers[l]["DAMAGE"] + d, 1)
    limb.layers = layers
    pass

#detaches limb and children
func detachlimb(limb):
    limb.attached = false
    for n in limb.get_children():
        detachlimb(n)

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
        status = status || checklimb(node)
    return status && vital

#check status of an individual limb
func checklimb(limb):
    if limb.attached:
        for l in limb.layers:
            if limb.layers[l]["INTEGRITY"] > systemThreshold:
                return true
    return false

func _process(delta):
    processsystems(delta)
    pass

#system process function
func processsystems(delta):
    processcirc(delta)
    processstruc(delta)
    for s in _status.keys():
        _status[s] = checkstatus(s);
        if s == "CIRCULATION":
            if blood < bleedOutThreshHold:
                _status[s] = false
    pass

#circulitory system proccess function
func processcirc(delta):
    if !checksystem("CIRCULATION"):
        return
    for limb in getsystem("CIRCULATION"):
        var node = get_node(limb)
        if node.attached:
            for layer in node.layers.keys():
                if _materialdata.has(layer):
                    for f in _materialdata[layer].flags:
                        if f == "VASCULAR":
                            bleed(node.layers[layer]["DAMAGE"] * vesselBleedRate * delta)
                            if(node.layers[layer]["DAMAGE"] > 0):
                                node.layers[layer]["DAMAGE"] = max(node.layers[layer]["DAMAGE"] - vesselHealRate * delta, 0)
                        if f == "ARTERY":
                            bleed(node.layers[layer]["DAMAGE"] * arteryBleedRate * delta)
    pass

#structure system process function
func processstruc(delta):
    if !checksystem("STRUCTURE"):
        return
    for limb in getsystem("STRUCTURE"):
        var node = get_node(limb)
        if node.attached:
            for layer in node.layers.keys():
                if _materialdata.has(layer):
                    for f in _materialdata[layer].flags:
                        if f == "STRUCTURE":
                            if node.layers[layer]["INTEGRITY"] < structureDetachThreshold:
                                detachlimb(node)
    pass

func bleed(amount):
    blood -= amount
    pass
