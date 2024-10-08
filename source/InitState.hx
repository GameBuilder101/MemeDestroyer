package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.addons.transition.FlxTransitionableState;
import flixel.util.FlxTimer;
import gbc.graphics.AssetSprite;
import gbc.graphics.AssetSpriteRegistry;
import gbc.graphics.TransitionDataRegistry;
import lime.app.Application;
import ui.title.TitleState;

class InitState extends FlxState
{
	override function create()
	{
		super.create();
		Application.current.window.maximized = true; // Maximize the application by default

		// Set up the cursor
		var cursor:AssetSpriteData = AssetSpriteRegistry.getAsset("ui/_shared/sprites/cursor");
		FlxG.mouse.load(cursor.graphic.bitmap, 1.0, -cast(cursor.graphic.width / 2.0, Int), -cast(cursor.graphic.height / 2.0, Int));

		// Set up default transitions
		FlxTransitionableState.defaultTransIn = TransitionDataRegistry.getAsset("transitions/default_in");
		FlxTransitionableState.defaultTransOut = TransitionDataRegistry.getAsset("transitions/default_out");

		// Must be done here so that FlxG has time to initialize
		Settings.instance = new Settings();

		// Give the game a moment to start
		new FlxTimer().start(1.0, function(timer:FlxTimer)
		{
			FlxG.switchState(new TitleState());
		});
	}
}
