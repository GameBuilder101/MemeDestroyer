package ui;

import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import gbc.graphics.AssetSprite;
import gbc.sound.AssetSound;
import gbc.sound.AssetSoundRegistry;

/** An indicator which displays a counting number and an icon. **/
class IconIndicator extends FlxSpriteGroup implements IIndicator
{
	/** How long it takes to change the value. **/
	static inline final COUNT_DELAY:Float = 0.04;

	var currentValue:Float;
	var targetValue:Float;
	var currentCountDelay:Float;
	var setInitialValue:Bool; // The first time the value is set, the count is immediate

	var label:FlxText;
	var icon:AssetSprite;

	var indicatorColor:FlxColor = FlxColor.WHITE;

	/** How long each flash takes during the flash animation. **/
	static inline final FLASH_DELAY:Float = 0.1;

	var flashTimer:FlxTimer;
	var flashSound:AssetSound;

	public function new(x:Float = 0.0, y:Float = 0.0, iconID:String, flashSoundID:String = null)
	{
		super(x, y);
		scrollFactor.set(0.0, 0.0);

		label = new FlxText(0.0, 6.0, 512.0, "0");
		label.setFormat("Edit Undo BRK", 20, FlxColor.WHITE, RIGHT, SHADOW, FlxColor.BLACK);
		add(label);

		icon = new AssetSprite(label.width + 6.0, 0.0, null, iconID);
		add(icon);

		flashTimer = new FlxTimer();
		if (flashSoundID != null)
			flashSound = AssetSoundRegistry.getAsset(flashSoundID);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		if (currentValue == targetValue) // If the values are up-to-date
			return;

		// Count the current value to the target value over time
		if (currentCountDelay <= 0.0)
		{
			if (currentValue < targetValue)
				currentValue++;
			else
				currentValue--;
			label.text = currentValue + "";
			currentCountDelay = COUNT_DELAY;
		}
		else
			currentCountDelay -= elapsed;
	}

	public function setValues(current:Float, max:Float)
	{
		targetValue = current;
		currentCountDelay = 0.0;

		if (!setInitialValue)
		{
			currentValue = targetValue;
			label.text = currentValue + "";
		}
		setInitialValue = true;
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

	/** Plays a animation to flash the color of the indicator. **/
	public function flash(color:FlxColor)
	{
		flashTimer.cancel();
		label.color = color;
		icon.color = color;
		flashTimer.start(FLASH_DELAY, function(timer:FlxTimer)
		{
			if (timer.elapsedLoops % 2 == 0)
			{
				label.color = color;
				icon.color = color;
			}
			else
			{
				label.color = indicatorColor;
				icon.color = indicatorColor;
			}
		}, 7);

		if (flashSound != null)
			flashSound.play();
	}
}
