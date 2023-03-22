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
	var cap:AssetSprite;

	var label:FlxText;

	/* Used to track updates to the values. */
	var prevCurrent:Float = -1.0;

	public function new(x:Float = 0.0, y:Float = 0.0)
	{
		super(x, y);

		back = new AssetSprite(0.0, 20.0, null, "ui/hud/health_bar_back");
		add(back);

		fill = new AssetSprite(0.0, 20.0, null, "ui/hud/health_bar_fill");
		add(fill);

		cap = new AssetSprite(0.0, 20.0, null, "ui/hud/health_bar_cap");
		add(cap);

		label = new FlxText(0.0, 0.0, width);
		label.setFormat("Edit Undo BRK", 20, FlxColor.WHITE, CENTER, SHADOW, FlxColor.BLACK);
		add(label);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		if (cap.animation.finished)
			cap.animation.play("idle");
	}

	public function setValues(current:Float, max:Float)
	{
		cast(fill.shader, FillShader).setProgress(current / max);
		// Move the cap to match the fill
		cap.x = fill.x + fill.width * (current / max);
		if (current > prevCurrent)
			cap.animation.play("heal")
		else if (current < prevCurrent)
			cap.animation.play("hurt");

		prevCurrent = current;
	}

	public function setLabel(label:String)
	{
		this.label.text = label;
	}

	public function setIndicatorColor(color:FlxColor)
	{
		fill.color = color;
		cap.color = color;

		label.color = color;
	}
}
