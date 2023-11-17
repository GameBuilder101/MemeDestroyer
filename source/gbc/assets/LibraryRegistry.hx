package gbc.assets;

import haxe.Json;
import sys.io.File;

using StringTools;

class LibraryRegistry extends Registry<Library>
{
	public function parse(data:Dynamic):Library
	{
		if (data == null)
			return null;
		if (data.name == null)
			data.name = "";
		if (data.description == null)
			data.description = "";
		return new Library(data.name, data.description, data.version, data.dependencies);
	}

	public function export(item:Library, path:String)
	{
		var desc:String = Json.stringify({
			name: item.name,
			description: item.description,
			version: item.version,
			dependencies: item.dependencies
		});
		File.write(path + "/library.json").writeString(desc);
	}

	function load(path:String):Library
	{
		return parse(FileManager.getParsedJson(path + "/library"));
	}
}
