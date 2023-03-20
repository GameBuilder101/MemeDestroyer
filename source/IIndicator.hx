package;

import flixel.util.FlxColor;

/** Interface for things such as health bars. **/
interface IIndicator
{
	public function setValues(current:Float, max:Float):Void;

	public function setLabel(label:String):Void;

	public function setIndicatorColor(color:FlxColor):Void;
}
