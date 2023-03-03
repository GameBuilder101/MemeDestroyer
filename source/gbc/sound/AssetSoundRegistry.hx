package gbc.sound;

import gbc.assets.FileManager;
import gbc.assets.LibraryManager;
import gbc.assets.Registry;
import gbc.sound.AssetSound;
import haxe.Json;
import openfl.media.Sound;

class AssetSoundRegistry extends Registry<AssetSound>
{
	public function parse(data:Dynamic):AssetSound
	{
		if (data != null)
		{
			var variants:Array<AssetSoundVariant> = [];
			var i:Int = 0;
			for (variant in cast(data.desc, Array<Dynamic>))
			{
				variants.push({sound: data.sounds[i], volume: variant.volume});
				i++;
			}
			return new AssetSound(variants);
		}
		else if (data.sound != null) // If it's just a sound file without a JSON
			return new AssetSound(null, {sound: data.sound, volume: 1.0});
		return null;
	}

	public function export(item:AssetSound, path:String)
	{
		var variants:Array<Dynamic> = [];
		var i:Int = 0;
		for (variant in item.variants)
		{
			variants.push({path: path + "_" + i, volume: variant.volume});
			i++;
		}
		var desc:String = Json.stringify(variants);
		FileManager.writeJson(path, desc);
	}

	function load(path:String):AssetSound
	{
		var desc:Dynamic = FileManager.getParsedJson(path);
		var sounds:Array<Sound> = [];
		for (variant in cast(desc, Array<Dynamic>))
			sounds.push(FileManager.getSound(variant.path));
		return parse({
			sound: FileManager.getSound(path),
			sounds: sounds,
			desc: desc
		});
	}

	public static function getAsset(id:String):AssetSound
	{
		return LibraryManager.getAsset(id, AssetSoundRegistry);
	}

	public static function getAssetID(item:AssetSound):String
	{
		return LibraryManager.getAssetID(item, AssetSoundRegistry);
	}
}
