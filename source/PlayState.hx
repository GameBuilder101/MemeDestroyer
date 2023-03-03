package;

import entity.Entity;
import flixel.FlxState;

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
		sort(function(order:Int, Obj1:MySprite, Obj2:MySprite):Int
		{
			return FlxSort.byValues(order, Obj1.zDepth, Obj2.zDepth);
		}, FlxSort.ASCENDING);
	}
}
