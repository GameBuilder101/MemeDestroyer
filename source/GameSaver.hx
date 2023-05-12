package;

import gbc.Saver;
import gbc.assets.FileManager;
import sys.FileSystem;

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
		return {name: "game", date: null, gameData: {}};
	}

	override function save(path:String = null)
	{
		if (path == null || path == "")
			path = SAVES_DIRECTORY + "/0";
		data.date = Date.now() + "";
		super.save(path);
	}

	override function load(path:String = null)
	{
		if (path == null || path == "")
		{
			path = SAVES_DIRECTORY + "/0";
			currentID = 0;
		}
		super.load(path);
	}

	/** Saves the game using an ID. **/
	public inline function saveGame(id:Int)
	{
		save(SAVES_DIRECTORY + "/" + id);
	}

	/** Loads the game using an ID. **/
	public inline function loadGame(id:Int)
	{
		load(SAVES_DIRECTORY + "/" + id);
		currentID = id;
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
	gameData:Dynamic
}
