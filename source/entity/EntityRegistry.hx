package entity;

import entity.Entity;
import gbc.assets.FileManager;
import gbc.assets.LibraryManager;
import gbc.assets.Registry;
import haxe.Json;

class EntityRegistry extends Registry<EntityData>
{
	public function parse(data:Dynamic):EntityData
	{
		if (data == null)
			return null;
		if (data.sortingPriority == null)
			data.sortingPriority = 0;
		return data;
	}

	public function export(item:EntityData, path:String)
	{
		var desc:String = Json.stringify(item);
		FileManager.writeJson(path + "/entity", desc);
	}

	function load(path:String):EntityData
	{
		return parse(FileManager.getParsedJson(path + "/entity"));
	}

	public static function getAsset(id:String):EntityData
	{
		return LibraryManager.getAsset(id, EntityRegistry);
	}

	public static function getAssetID(item:EntityData):String
	{
		return LibraryManager.getAssetID(item, EntityRegistry);
	}
}
