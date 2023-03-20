package;

import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import gbc.graphics.AssetSprite;
import shaders.FillShader;

class HealthBar extends FlxSpriteGroup implements IIndicator
{
	var back:AssetSprite;
	var fill:AssetSprite;
	var label:FlxText;

	public function new(x:Float = 0.0, y:Float = 0.0)
	{
		super(x, y);
		back = new AssetSprite(0.0, 0.0, null, "ui/hud/health_bar_back");
		back.setPosition(-back.width / 2.0, -back.height);
		add(back);

		fill = new AssetSprite(0.0, 0.0, null, "ui/hud/health_bar_fill");
		fill.setPosition(-fill.width / 2.0, -fill.height);
		add(fill);

		label = new FlxText(0.0, 0.0, width);
		label.setPosition(-label.width / 2.0, -height - 16.0);
		label.setFormat("Edit Undo BRK", 20, FlxColor.WHITE, CENTER, SHADOW, FlxColor.BLACK);
		add(label);
	}

	public function setValues(current:Float, max:Float)
	{
		cast(fill.shader, FillShader).setProgress(current / max);
	}

	public function setLabel(label:String)
	{
		this.label.text = label;
	}

	public function setIndicatorColor(color:FlxColor)
	{
		fill.color = color;
		label.color = color;
	}
}
