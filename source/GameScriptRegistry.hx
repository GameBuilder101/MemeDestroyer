package;

import gbc.assets.FileManager;
import gbc.assets.LibraryManager;
import gbc.assets.Registry;
import haxe.Json;

class GameScriptRegistry extends Registry<GameScript>
{
	public function parse(data:Dynamic):GameScript
	{
		if (data == null || data.script == null)
			return null;
		return new GameScript(data.script, data.name);
	}

	public function export(item:GameScript, path:String)
	{
		var script:String = Json.stringify(item.script);
		FileManager.writeHScript(path, script);
	}

	function load(path:String):GameScript
	{
		return parse({
			script: FileManager.getHScript(path),
			name: path
		});
	}

	public static function getAsset(id:String):GameScript
	{
		return LibraryManager.getAsset(id, GameScriptRegistry);
	}

	public static function getAssetID(item:GameScript):String
	{
		return LibraryManager.getAssetID(item, GameScriptRegistry);
	}
}
