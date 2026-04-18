@tool
extends Node

@export_tool_button("Save Card", "Callable") var card_to_save = create_card_json_entry
@export var card_folder_file_path : String = "res://Scenes/Cards/"
@export var settings_resource : SlottableData

var json_card_file_path = "res://Resources/JSONs/Cards.json"
var resource_file_path = "res://Resources/CustomResources/SlottableData.gd"
var working_card_dict = {}


func get_attributes_from_resource(data : SlottableData) -> Dictionary:
	var return_dict = {}
	return_dict["card_name"] = data.card_name
	return_dict["prime_number"] = data.prime_number
	return_dict["description"] = data.description
	return_dict["flavor_text"] = data.flavor_text
	return_dict["tags"] = data.tags
	return_dict["card_type"] = data.card_type
	return_dict["rank"] = data.rank
	return return_dict


## Saving
func create_card_json_entry(card : AbstractCard, card_elements : Dictionary):
	var json_text = "\"%s\" : {\n" % [card.card_name]
	for element in card_elements.keys():
		json_text += "\t\"%s\" : %s,\n" % [element, card_elements[element]]
	json_text += "},"
	return json_text



func get_json_dict(file_path : String):
	var json_file : FileAccess = FileAccess.open(file_path, FileAccess.READ)
	var json_text = json_file.get_as_text().strip_edges(true, true)
	var json = JSON.new()
	var parse_result = json.parse(json_text)
	if parse_result == OK:
		var data = json.data
		json_file.close()
		if data is Dictionary:
			return data
		else:
			return null
	else:
		print_debug("JSON Read error")
		return null


func save_dict_to_json(dict : Dictionary, file_path : String):
	var json_file : FileAccess = FileAccess.open(file_path, FileAccess.WRITE)
	var json_string = JSON.stringify(dict, "\t")
	json_file.store_line(json_string)
	json_file.close()


## Loading
func load_cards():
	var json_file : FileAccess = FileAccess.open(json_card_file_path, FileAccess.READ)
	var json_text = json_file.get_as_text().strip_edges(true, true)
	var json = JSON.new()
	var parse_result = json.parse(json_text)
	if parse_result == OK:
		working_card_dict = json.data


func construct_card(file_path) -> AbstractCard:
	var card_scene = load_card_scene_from_path(file_path)
	var card_object = card_scene.instantiate()
	return card_object


func load_card_scene_from_path(file_path: String) -> PackedScene:
	if file_path == "" or not ResourceLoader.exists(file_path):
		push_error("Error: Scene file not found at: " + file_path)
		return null
	
	var scene = load(file_path) as PackedScene
	
	if not scene:
		push_error("Error: File at " + file_path + " is not a valid PackedScene.")
		return null
	
	return scene
