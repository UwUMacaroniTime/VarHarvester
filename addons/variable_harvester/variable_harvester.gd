@tool
extends EditorPlugin

const VAR_HARVESTER_TYPENAME:String = ""
const VAR_HARVESTER_INHERITS_FROM:String = ""

func _enter_tree():
	add_custom_type(VAR_HARVESTER_TYPENAME, \
	VAR_HARVESTER_INHERITS_FROM, \
	preload("VariableHarvesterType.gd"), \
	preload("icons-solid.svg"))
	


func _exit_tree():
	remove_custom_type(VAR_HARVESTER_TYPENAME)
	# Clean-up of the plugin goes here.
	pass
