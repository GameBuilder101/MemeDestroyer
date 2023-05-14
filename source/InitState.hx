package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.addons.transition.FlxTransitionableState;
import gbc.graphics.TransitionDataRegistry;

class InitState extends FlxState
{
	override function create()
	{
		super.create();
		FlxTransitionableState.defaultTransIn = TransitionDataRegistry.getAsset("transitions/default_in");
		FlxTransitionableState.defaultTransOut = TransitionDataRegistry.getAsset("transitions/default_out");
		FlxG.switchState(new PlayState());
	}
}
