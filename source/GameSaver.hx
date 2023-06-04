package;

import gbc.Saver;
import gbc.assets.FileManager;
import sys.FileSystem;

using DateTools;

/** Used to save/load game data for a playthrough. **/
class GameSaver extends Saver<GameSave>
{
	static inline final SAVES_DIRECTORY:String = "saves";

	public static var instance:GameSaver = new GameSaver();

	/** The ID of the latest save game that was loaded. -1 by default. **/
	public var currentID(default, null):Int = -1;

	function getSaverMethod():SaverMethod
	{
		return JSON;
	}

	function getDefaultData():GameSave
	{
		return {name: "game", date: null, data: []};
	}

	override function save(path:String = null)
	{
		if (path == null || path == "")
			path = "save";
		data.date = Date.now().format("%F %r") + "";
		super.save(path);
	}

	override function load(path:String = null)
	{
		if (path == null || path == "")
		{
			path = "save";
			currentID = 0;
		}
		super.load(path);
	}

	/** Sets a value to be remembered/used later. **/
	public function setGameData(key:String, value:Dynamic)
	{
		for (gameData in data.data)
		{
			if (gameData.key == key)
			{
				gameData.value = value;
				return;
			}
		}
		data.data.push({key: key, value: value});
	}

	/** Removes a value that was remembered. **/
	public function removeGameData(key:String)
	{
		for (gameData in data.data)
		{
			if (gameData.key == key)
			{
				data.data.remove(gameData);
				return;
			}
		}
	}

	/** Returns a value that was remembered. **/
	public function getGameData(key:String):Dynamic
	{
		for (gameData in data.data)
		{
			if (gameData.key == key)
				return gameData.value;
		}
		return null;
	}

	/** Saves the game using an ID. **/
	public inline function saveGame(id:Int)
	{
		if (!FileSystem.exists(SAVES_DIRECTORY))
			FileSystem.createDirectory(SAVES_DIRECTORY);
		save(SAVES_DIRECTORY + "/" + id);
	}

	/** Loads the game using an ID. **/
	public inline function loadGame(id:Int)
	{
		load(SAVES_DIRECTORY + "/" + id);
		currentID = id;
	}

	/** Loads the game from a new save game. **/
	public function loadNewGame()
	{
		data = getDefaultData();
	}

	/** Returns the IDs of all saves in the save directory. **/
	public function getSaveIDs():Array<Int>
	{
		var ids:Array<Int> = [];
		var parsed:Int;
		for (id in FileSystem.readDirectory(SAVES_DIRECTORY))
		{
			parsed = Std.parseInt(id);
			if (parsed >= 0)
				ids.push(parsed);
		}
		return ids;
	}

	/** Returns the save data for a particular save. Null if the save doesn't exist. **/
	public inline function getSave(id:Int):GameSave
	{
		return FileManager.getParsedJson(SAVES_DIRECTORY + "/" + id);
	}

	/** Finds an ID for a new game save. **/
	public inline function findNewSaveID():Int
	{
		var id:Int = 0;
		while (FileSystem.exists(SAVES_DIRECTORY + "/" + id))
			id++;
		return id;
	}

	/** Creates a new game save by finding an avaliable ID. **/
	public inline function saveNewGame()
	{
		saveGame(findNewSaveID());
	}

	/** Saves the game using the current ID. **/
	public inline function saveCurrentGame()
	{
		saveGame(currentID);
	}
}

typedef GameSave =
{
	name:String,
	date:String,
	data:Array<GameData>
}

typedef GameData =
{
	key:String,
	value:Dynamic
}
