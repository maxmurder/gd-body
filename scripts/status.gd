
extends Label

export(String) var system
export(NodePath) var body

onready var _body = get_node(body)

func _ready():
    set_process(true)
    pass

func _process(delta):
    var s = "%s : %s"
    self.set_text(s % [system, _body.checksystem(system)])
    pass
