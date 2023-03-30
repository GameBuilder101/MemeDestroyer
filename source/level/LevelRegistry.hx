package level;

import gbc.assets.FileManager;
import gbc.assets.LibraryManager;
import gbc.assets.Registry;
import haxe.Json;
import level.Level;

class LevelRegistry extends Registry<LevelData>
{
	public function parse(data:Dynamic):LevelData
	{
		if (data == null)
			return null;
		return data;
	}

	public function export(item:LevelData, path:String)
	{
		var desc:String = Json.stringify(item);
		FileManager.writeJson(path + "/level", desc);
	}

	function load(path:String):LevelData
	{
		return parse(FileManager.getParsedJson(path + "/level"));
	}

	public static function getAsset(id:String):LevelData
	{
		return LibraryManager.getAsset(id, LevelRegistry);
	}

	public static function getAssetID(item:LevelData):String
	{
		return LibraryManager.getAssetID(item, LevelRegistry);
	}
}
