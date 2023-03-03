package gbc;

import flixel.FlxG;
import gbc.assets.FileManager;
import haxe.Json;

/** A saver is a container for data which can be saved and re-loaded on game start. **/
abstract class Saver<T:Dynamic>
{
	public var data(default, null):T;

	public function new()
	{
		data = getDefaultData();
		load();
	}

	/** Used for either the field name when using FlxG.save or the file name when using JSON. **/
	abstract function getSaverID():String;

	/** Returns the method to use when saving. **/
	abstract function getSaverMethod():SaverMethod;

	abstract function getDefaultData():T;

	/** Saves the data to be re-loaded the next time the game is started. **/
	public function save()
	{
		switch (getSaverMethod())
		{
			case FLX_SAVE:
				Reflect.setField(FlxG.save.data, getSaverID(), data);
			case JSON:
				var json:String = Json.stringify(data, null, "    ");
				// Write to a JSON file
				FileManager.writeJson(getSaverID(), json);
		}
	}

	/** Loads any saved data (if there is none, this does nothing). **/
	public function load()
	{
		var data:Dynamic;
		switch (getSaverMethod())
		{
			case FLX_SAVE:
				data = Reflect.field(FlxG.save.data, getSaverID());
			case JSON:
				data = FileManager.getParsedJson(getSaverID());
		}

		// If no existing saved data was found, then stop
		if (data == null)
		{
			trace("No saved data found for Saver '" + getSaverID() + "'");
			return;
		}
		this.data = data;
	}
}

enum SaverMethod
{
	FLX_SAVE;
	JSON;
}
