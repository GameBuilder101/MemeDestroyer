package ui.pause_menu;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.util.FlxColor;

class PauseMenu extends FlxSubState
{
	var background:FlxSprite;

	override function create()
	{
		super.create();

		background = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		background.alpha = 0.5;
		add(background);
	}
}
