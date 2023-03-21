package;

import flixel.FlxG;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import gbc.graphics.AssetSprite;

class HealthNotches extends FlxSpriteGroup implements IIndicator
{
	var label:FlxText;
	var notches:Array<FlxSpriteGroup> = new Array<FlxSpriteGroup>();

	/* Used to track updates to the current value. */
	var prevValue:Int = -1;

	var indicatorColor:FlxColor = FlxColor.WHITE;

	public function new(x:Float = 0.0, y:Float = 0.0)
	{
		super(x, y);
		label = new FlxText(FlxG.width / 2.0, 0.0, FlxG.width);
		label.setFormat("Edit Undo BRK", 20, FlxColor.WHITE, CENTER, SHADOW, FlxColor.BLACK);
		add(label);
	}

	public function setValues(current:Float, max:Float)
	{
		var currentInt:Int = Math.ceil(current);
		var maxInt:Int = Math.ceil(max);

		var prevLength:Int = notches.length;
		// Make sure there are the correct number of notches
		while (notches.length < maxInt) // Add new notches to match
			createNotch();
		while (notches.length > maxInt) // Remove notches to match
			removeNotch();

		// Update the positions
		if (notches.length != prevLength)
		{
			for (i in 0...notches.length)
				notches[i].setPosition(x + (i - (notches.length * 0.5)) * notches[i].width, y + 20.0);
		}

		// Update the graphics
		if (notches.length != prevLength || currentInt != prevValue)
		{
			for (i in 0...notches.length)
				notches[i].members[1].visible = i < currentInt;
		}

		prevValue = currentInt;

		// Since new notches may have been added
		updateIndicatorColor();
	}

	function createNotch()
	{
		var notch:FlxSpriteGroup = new FlxSpriteGroup();
		notch.add(new AssetSprite(0.0, 0.0, null, "ui/hud/health_notch_back"));
		notch.add(new AssetSprite(0.0, 0.0, null, "ui/hud/health_notch_fill"));
		add(notch);
		notches.push(notch);
	}

	function removeNotch()
	{
		remove(notches[notches.length - 1], true);
		notches.pop();
	}

	public function setLabel(label:String)
	{
		this.label.text = label;
	}

	public function setIndicatorColor(color:FlxColor)
	{
		indicatorColor = color;
		updateIndicatorColor();
	}

	function updateIndicatorColor()
	{
		for (notch in notches)
			notch.members[1].color = indicatorColor;
	}
}
