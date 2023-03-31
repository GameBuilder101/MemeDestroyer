package;

import flixel.group.FlxSpriteGroup;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import gbc.graphics.AssetSprite;
import gbc.sound.AssetSound;
import gbc.sound.AssetSoundRegistry;

/** A notification overlay that plays a Dark-Souls-esque animation. **/
class NotificationOverlay extends FlxSpriteGroup
{
	var mainSprite:AssetSprite;

	var mainSound:AssetSound;

	public function new(x:Float = 0.0, y:Float = 0.0, spriteID:String = "", soundID:String = "")
	{
		super(x, y);

		mainSprite = new AssetSprite(0.0, 0.0, null, spriteID);
		add(mainSprite);
		mainSprite.visible = false;

		mainSound = AssetSoundRegistry.getAsset(soundID);
	}

	/** Plays an animation on the overlay. **/
	public function display()
	{
		FlxTween.cancelTweensOf(mainSprite);
		mainSprite.scale.set(1.0, 1.0);
		mainSprite.visible = true;
		FlxTween.tween(mainSprite, {"scale.x": 1.2, "scale.y": 1.2}, 5.0, {ease: FlxEase.linear});
		FlxTween.color(mainSprite, 2.5, FlxColor.fromString("#ffffff00"), FlxColor.WHITE, {onComplete: onCompleteFadeIn});

		mainSound.play();
	}

	/** Called when the fade-in is finished. **/
	function onCompleteFadeIn(tween:FlxTween)
	{
		FlxTween.color(mainSprite, 2.5, FlxColor.WHITE, FlxColor.fromString("#ffffff00"), {onComplete: onCompleteFadeOut});
	}

	/** Called when the fade-out is finished. **/
	function onCompleteFadeOut(tween:FlxTween)
	{
		mainSprite.visible = false;
	}
}
