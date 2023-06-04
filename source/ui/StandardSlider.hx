package ui;

import flixel.FlxG;
import flixel.group.FlxSpriteGroup;
import flixel.ui.FlxBar;
import flixel.util.FlxColor;
import gbc.graphics.AssetSprite;
import gbc.graphics.AssetSpriteRegistry;

class StandardSlider extends FlxSpriteGroup
{
	public var back(default, null):AssetSprite;
	public var fill(default, null):FlxBar;
	public var handle(default, null):StandardButton;

	public var icon(default, null):AssetSprite;

	/** True while the user is sliding the handle. **/
	var usingHandle:Bool;

	/** A value from 0 to 1, with 1 representing the slider as full and 0 as empty. Setting will change the current value if not being interacted with. **/
	public var value:Float;

	public function new(x:Float = 0.0, y:Float = 0.0, iconID:String)
	{
		super(x, y);
		scrollFactor.set(0.0, 0.0);

		back = new AssetSprite(0.0, 0.0, null, "ui/_shared/sprites/slider_back");
		add(back);

		fill = new FlxBar(0.0, 0.0, LEFT_TO_RIGHT, cast(back.width, Int), cast(back.height, Int));
		fill.createImageBar(null, AssetSpriteRegistry.getAsset("ui/_shared/sprites/slider_fill").graphic, FlxColor.TRANSPARENT);
		add(fill);

		handle = new StandardButton(0.0, 0.0, "ui/_shared/sprites/slider_handle", "", CENTER, onHandleUp);
		handle.button.onDown.callback = onHandleDown;
		add(handle);

		icon = new AssetSprite(back.width + 6.0, 0.0, null, iconID);
		add(icon);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		// Fix issue where onHandleUp is not called when the handle is released outside of the handle
		if (usingHandle && !FlxG.mouse.pressed)
			onHandleUp();

		if (usingHandle)
		{
			// First, position the handle to the mouse cursor, while keeping it in the slider range
			handle.setPosition(FlxG.mouse.x - handle.width / 2.0, FlxG.mouse.y);
			handle.y = y;
			var max:Float = x + back.width - handle.width;
			if (handle.x < x)
				handle.x = x;
			else if (handle.x > max)
				handle.x = max;

			// Then, use math to update the slider value
			value = (handle.x - x) / (back.width - handle.width);
		}
		else // If not using the handle, instead update the handle position to match the current value
			handle.x = x + (back.width - handle.width) * value;

		fill.percent = value * 100.0;
	}

	/** Called when the handle is pressed. **/
	function onHandleDown()
	{
		usingHandle = true;
	}

	/** Called when the handle is released. **/
	function onHandleUp()
	{
		usingHandle = false;
	}
}
