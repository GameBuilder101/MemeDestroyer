package;

import entity.Entity;
import flixel.FlxBasic;
import flixel.FlxState;
import flixel.util.FlxSort;

class PlayState extends FlxState
{
	var player:Entity;

	override function create()
	{
		super.create();
		player = new Entity(0.0, 0.0, null, "entities/player");
		add(player);
		add(new Entity(100.0, 100.0, null, "items/nokia"));
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		sort(function(order:Int, value1:FlxBasic, value2:FlxBasic):Int
		{
			return FlxSort.byY(order, cast value1, cast value2);
		}, FlxSort.ASCENDING);
	}
}
