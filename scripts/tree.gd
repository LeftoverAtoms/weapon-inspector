extends Control

@export var gdt: GDT

@export var browser: Tree
@export var viewer: Tree


func _ready() -> void:
	for weapon_name: String in gdt.entries.keys():
		browser.create_item().set_text(0, weapon_name)


func _on_browser_item_selected() -> void:
	viewer.clear()

	var weapon_name: String = browser.get_selected().get_text(0)
	var weapon_data: Dictionary = gdt.entries.get(weapon_name, {})

	for key: String in weapon_data.keys():
		viewer.create_item().set_text(0, key + "    " + weapon_data.get(key))
