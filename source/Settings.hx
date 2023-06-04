package;

import flixel.FlxG;
import gbc.Saver;

class Settings extends Saver<Dynamic>
{
	static inline final DEFAULT_SAVE_PATH:String = "settings";

	public static var instance:Settings;

	public function new()
	{
		super();
		setGlobalVolume(getGlobalVolume()); // Update the volume
	}

	function getSaverMethod():SaverMethod
	{
		return JSON;
	}

	function getDefaultData():Dynamic
	{
		return {globalVolume: FlxG.sound.volume};
	}

	override function save(path:String = null)
	{
		if (path == null || path == "")
			path = DEFAULT_SAVE_PATH;
		super.save(path);
	}

	override function load(path:String = null)
	{
		if (path == null || path == "")
			path = DEFAULT_SAVE_PATH;
		super.load(path);
	}

	public function getGlobalVolume():Float
	{
		return data.globalVolume;
	}

	public function setGlobalVolume(value:Float)
	{
		data.globalVolume = value;
		FlxG.sound.volume = data.globalVolume;
	}
}
