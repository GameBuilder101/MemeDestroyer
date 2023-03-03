package gbc.scripting;

import flixel.math.FlxPoint;

/** An FlxPoint class wrapper for use in scripts. **/
class Point
{
	public var point:FlxPoint;

	public function new(x:Float = 0.0, y:Float = 0.0)
	{
		point = new FlxPoint(x, y);
	}

	public function normalize()
	{
		point.normalize();
	}
}
