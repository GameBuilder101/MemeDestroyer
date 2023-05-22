package ui;

import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import gbc.graphics.AssetSprite;

class MoneyIndicator extends FlxSpriteGroup implements IIndicator
{
	var label:FlxText;
	var icon:AssetSprite;

	var indicatorColor:FlxColor = FlxColor.WHITE;

	public function new(x:Float = 0.0, y:Float = 0.0)
	{
		super(x, y);
		scrollFactor.set(0.0, 0.0);

		label = new FlxText(0.0, 6.0, 512.0, "0");
		label.setFormat("Edit Undo BRK", 20, FlxColor.WHITE, RIGHT, SHADOW, FlxColor.BLACK);
		add(label);

		icon = new AssetSprite(label.width + 6.0, 0.0, null, "ui/_shared/sprites/money_icon");
		add(icon);
	}

	public function setValues(current:Float, max:Float)
	{
		label.text = current + "";
	}

	public function setLabel(label:String) {}

	public function setIndicatorColor(color:FlxColor)
	{
		indicatorColor = color;
		label.color = color;
		icon.color = color;
	}

	public function getIndicatorColor():FlxColor
	{
		return indicatorColor;
	}
}
