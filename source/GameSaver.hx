package;

import gbc.Saver;
import gbc.assets.FileManager;
import sys.FileSystem;

/** Used to save/load game data for a playthrough. **/
class GameSaver extends Saver<GameSave>
{
	static inline final SAVES_DIRECTORY:String = "saves";
	static inline final DEFAULT_SAVE_PATH:String = SAVES_DIRECTORY + "/game_save_";

	public static var instance:GameSaver = new GameSaver();

	/** The ID of the latest save game that was loaded. -1 by default. **/
	public var currentID(default, null):Int = -1;

	function getSaverMethod():SaverMethod
	{
		return JSON;
	}

	function getDefaultData():GameSave
	{
		return {name: null, date: null, gameData: {}};
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

	/** Saves the game using an ID. **/
	public function saveGame(id:Int, name:String = null)
	{
		if (name != null)
			data.name = name;
		data.date = Date.now() + "";
		save(DEFAULT_SAVE_PATH + id);
	}

	/** Loads the game using an ID. **/
	public function loadGame(id:Int)
	{
		load(DEFAULT_SAVE_PATH + id);
	}

	/** Returns the IDs of all saves in the save directory. **/
	public function getSaveIDs():Array<Int>
	{
		var ids:Array<Int> = [];
		var parsed:Int;
		for (id in FileSystem.readDirectory(SAVES_DIRECTORY))
		{
			parsed = Std.parseInt(id);
			if (parsed != null)
				ids.push(parsed);
		}
		return ids;
	}

	/** Returns the save data for a particular save. Null if the save doesn't exist. **/
	public inline function getSave(id:Int):GameSave
	{
		return FileManager.getParsedJson(DEFAULT_SAVE_PATH + id);
	}

	/** Finds an ID for a new game save. **/
	public inline function findNewSaveID():Int
	{
		var id:Int = 0;
		while (FileSystem.exists(DEFAULT_SAVE_PATH + id))
			id++;
		return id;
	}

	/** Creates a new game save by finding an avaliable ID. **/
	public function saveNewGame(name:String)
	{
		saveGame(findNewSaveID(), name);
	}

	/** Saves the game using the current ID. **/
	public function saveCurrentGame()
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
