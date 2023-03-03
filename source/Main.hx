package;

import flixel.FlxGame;
import gbc.assets.LibraryManager;
import openfl.display.Sprite;

class Main extends Sprite
{
	public function new()
	{
		super();
		LibraryManager.reloadAll();
		addChild(new FlxGame(0, 0, PlayState, 60, 60, true));
	}
}
