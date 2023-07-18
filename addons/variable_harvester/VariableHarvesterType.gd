@tool
@icon("icons-solid.svg")
class_name VariableHarvester
extends Node

const MUST_BE_ROOT = "non-scene linked VariableHarvesters expects to be scene root."
const HIGHLANDER_CHILD = "VariableHarvesters expect at least one child."

var properties:Array[String] = []:
	set(value):
		properties = value
		if Engine.is_editor_hint():
			property_list_changed.emit()

func _get_property_list():
	var export_properties := []
	var child_properties_ls := ""
	
	
	
	var datapoint:bool = false
	for i in get_children():
		var child_properties :Array[Dictionary] = i.get_property_list()
		for idx in len(child_properties):
			var ch :Dictionary = child_properties[idx]
			ch.name = i.name + ":" + ch.name
			
			if ch.name in properties:
				export_properties.append(ch)
			
			if ch.has("usage") and (ch.usage == PROPERTY_USAGE_CATEGORY or \
			ch.usage == PROPERTY_USAGE_SUBGROUP or \
			ch.usage == PROPERTY_USAGE_GROUP or \
			ch.usage == PROPERTY_USAGE_NO_EDITOR):
				continue
			if datapoint:
				child_properties_ls += ","
			child_properties_ls += ch.name
			datapoint = true
	
	export_properties.append({
		"name":"properties",
		"type": TYPE_ARRAY,
		"usage":PROPERTY_USAGE_DEFAULT,
		"hint":PROPERTY_HINT_TYPE_STRING,
		"hint_string": "%d/%d:%s" % [TYPE_STRING, PROPERTY_HINT_ENUM, child_properties_ls]
	})
	return export_properties

func _set(property, value):
	if property in properties:
		var split :Array = property.split(":", true, 2)
		get_node(split[0]).set(split[1], value)
		return true
	else:
		return false

func _get(property):
	if property in properties:
		var split :Array = property.split(":", true, 2)
		return get_node(split[0]).get(split[1])
	else:
		return null

func _ready():
	for s in [child_entered_tree, \
	child_exiting_tree]:
		if s.is_connected(update_configuration_warnings):
			continue
		connect(s.get_name(), update_configuration_warnings)
	
#
#func _get_configuration_warnings():
#	var warnings:Array[String]
#	if get_child_count() < 1:
#		warnings.append(HIGHLANDER_CHILD)
#		properties = []
#	return warnings
