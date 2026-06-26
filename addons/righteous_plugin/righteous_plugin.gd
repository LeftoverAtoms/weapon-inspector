@tool
extends EditorPlugin

var _gdt_import_plugin: GDTImportPlugin


func _enter_tree() -> void:
	_gdt_import_plugin = GDTImportPlugin.new()

	add_import_plugin(_gdt_import_plugin)


func _exit_tree() -> void:
	remove_import_plugin(_gdt_import_plugin)
