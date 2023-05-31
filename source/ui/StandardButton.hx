package ui;

import flixel.group.FlxSpriteGroup;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import gbc.graphics.AssetSprite;
import gbc.sound.AssetSound;
import gbc.sound.AssetSoundRegistry;

/** A class for general-purpose buttons. **/
class StandardButton extends FlxSpriteGroup
{
	public var background(default, null):AssetSprite;
	public var button(default, null):FlxButton;

	var highlightSound:AssetSound;
	var pressSound:AssetSound;

	public function new(x:Float = 0.0, y:Float = 0.0, spriteID:String = "ui/_shared/sprites/button", text:String = "", alignment:FlxTextAlign = CENTER,
			onClick:Void->Void)
	{
		super(x, y);
		scrollFactor.set(0.0, 0.0);

		background = new AssetSprite(0.0, 0.0, null, spriteID);
		add(background);

		button = new FlxButton(0.0, 0.0, text);
		button.makeGraphic(cast(background.width, Int), cast(background.height, Int), FlxColor.TRANSPARENT); // Disable the default button graphic
		button.label.fieldWidth = background.width - 24.0;
		button.labelOffsets = [new FlxPoint(12.0, 6.0), new FlxPoint(12.0, 6.0), new FlxPoint(12.0, 8.0)];
		button.label.setFormat("Edit Undo BRK", 20, FlxColor.WHITE, alignment, SHADOW, FlxColor.BLACK);
		add(button);

		highlightSound = AssetSoundRegistry.getAsset("ui/_shared/sounds/button_highlight");
		pressSound = AssetSoundRegistry.getAsset("ui/_shared/sounds/button_pressed");

		button.onOver.callback = function()
		{
			highlightSound.play();
		}
		button.onUp.callback = function()
		{
			pressSound.play();
			onClick();
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		/** Update the background animations to match the button status. **/
		switch (button.status)
		{
			default:
				background.animation.play("idle");
			case FlxButton.HIGHLIGHT:
				background.animation.play("highlight");
			case FlxButton.PRESSED:
				background.animation.play("pressed");
		}
	}
}
