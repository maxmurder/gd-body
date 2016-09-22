
extends Label

export(NodePath) var body
onready var _b = get_node(body)

func _ready():
	set_process(true)
	pass

func _process(delta):
    self.set_text("BLOOD: %s" % _b.blood)
    pass
