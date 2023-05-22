package ui.combat_hud;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import gbc.graphics.AssetSprite;
import gbc.sound.AssetSound;
import gbc.sound.AssetSoundRegistry;

class HealthNotches extends FlxSpriteGroup implements IIndicator
{
	var notches:Array<FlxSpriteGroup> = [];

	var label:FlxText;

	/* Used to track updates to the values. */
	var prevCurrent:Int = -1;

	var indicatorColor:FlxColor = FlxColor.WHITE;

	var healSound:AssetSound;
	var hurtSound:AssetSound;

	public function new(x:Float = 0.0, y:Float = 0.0)
	{
		super(x, y);
		scrollFactor.set(0.0, 0.0);

		label = new FlxText(FlxG.width / 2.0, 0.0, FlxG.width);
		label.setFormat("Edit Undo BRK", 20, FlxColor.WHITE, CENTER, SHADOW, FlxColor.BLACK);
		add(label);

		healSound = AssetSoundRegistry.getAsset("ui/combat_hud/sounds/health_notch_heal");
		hurtSound = AssetSoundRegistry.getAsset("ui/combat_hud/sounds/health_notch_hurt");
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		// If finished a heal/hurt animation, the notches should play an idle animation
		var fill:FlxSprite;
		for (notch in notches)
		{
			fill = notch.members[1];
			if (!fill.animation.finished)
				continue;
			if (fill.animation.name == "hurt")
				fill.visible = false;
			else
				fill.animation.play("idle");
		}
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

		// Update the visuals and play animations
		for (i in 0...notches.length)
		{
			if (i > prevCurrent - 1 && i < currentInt) // If in heal range
			{
				notches[i].visible = true;
				notches[i].members[1].animation.play("heal", true);
			}
			else if (i < prevCurrent && i > currentInt - 1) // If in hurt range
			{
				notches[i].visible = true;
				notches[i].members[1].animation.play("hurt", true);
			}
		}

		if (currentInt > prevCurrent && healSound != null)
			healSound.play();
		else if (currentInt < prevCurrent && hurtSound != null)
			hurtSound.play();
		prevCurrent = currentInt;

		// Since new notches may have been added
		updateIndicatorColor();
	}

	function createNotch()
	{
		var notch:FlxSpriteGroup = new FlxSpriteGroup();
		notch.add(new AssetSprite(0.0, 0.0, null, "ui/combat_hud/sprites/health_notch_back"));
		notch.add(new AssetSprite(0.0, 0.0, null, "ui/combat_hud/sprites/health_notch_fill"));
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

	public function getIndicatorColor():FlxColor
	{
		return indicatorColor;
	}

	function updateIndicatorColor()
	{
		for (notch in notches)
			notch.members[1].color = indicatorColor;
	}
}
