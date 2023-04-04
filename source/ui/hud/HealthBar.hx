package ui.hud;

import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel_fixed.ui.FlxBar;
import gbc.graphics.AssetSprite;
import gbc.graphics.AssetSpriteRegistry;
import gbc.sound.AssetSound;
import gbc.sound.AssetSoundRegistry;

class HealthBar extends FlxSpriteGroup implements IIndicator
{
	var back:AssetSprite;
	var fill:FlxBar;
	var cap:AssetSprite;

	var label:FlxText;

	/* Used to track updates to the values. */
	var prevCurrent:Float = -1.0;

	var healSound:AssetSound;
	var hurtSound:AssetSound;

	public function new(x:Float = 0.0, y:Float = 0.0)
	{
		super(x, y);

		back = new AssetSprite(0.0, 20.0, null, "ui/hud/sprites/health_bar_back");
		add(back);

		fill = new FlxBar(0.0, 20.0, LEFT_TO_RIGHT, cast(back.width, Int), cast(back.height, Int));
		fill.createImageBar(null, AssetSpriteRegistry.getAsset("ui/hud/sprites/health_bar_fill").graphic, FlxColor.TRANSPARENT);
		add(fill);

		cap = new AssetSprite(0.0, 20.0, null, "ui/hud/sprites/health_bar_cap");
		add(cap);

		label = new FlxText(0.0, 0.0, width);
		label.setFormat("Edit Undo BRK", 20, FlxColor.WHITE, CENTER, SHADOW, FlxColor.BLACK);
		add(label);

		healSound = AssetSoundRegistry.getAsset("ui/hud/sounds/health_bar_heal");
		hurtSound = AssetSoundRegistry.getAsset("ui/hud/sounds/health_bar_hurt");
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		if (cap.animation.finished)
			cap.animation.play("idle");
	}

	public function setValues(current:Float, max:Float)
	{
		fill.percent = current / max * 100.0;
		// Move the cap to match the fill
		cap.x = fill.x + fill.width * (current / max);
		if (current > prevCurrent)
			cap.animation.play("heal");
		else if (current < prevCurrent)
			cap.animation.play("hurt");

		if (current > prevCurrent && healSound != null)
			healSound.play();
		else if (current < prevCurrent && hurtSound != null)
			hurtSound.play();
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
