package;

import flixel.group.FlxSpriteGroup;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import gbc.graphics.AssetSprite;
import gbc.sound.AssetSound;
import gbc.sound.AssetSoundRegistry;

/** A notification overlay that plays a Dark-Souls-esque animation. **/
class NotificationOverlay extends FlxSpriteGroup implements IOverlay
{
	var mainSprite:AssetSprite;

	var mainSound:AssetSound;

	var onComplete:Void->Void;

	public function new(x:Float = 0.0, y:Float = 0.0, spriteID:String = "", soundID:String = "")
	{
		super(x, y);

		mainSprite = new AssetSprite(0.0, 0.0, null, spriteID);
		add(mainSprite);
		mainSprite.visible = false;

		mainSound = AssetSoundRegistry.getAsset(soundID);
	}

	public function display(args:Dynamic, onComplete:Void->Void)
	{
		this.onComplete = onComplete;

		FlxTween.cancelTweensOf(mainSprite);
		mainSprite.scale.set(1.0, 1.0);
		mainSprite.alpha = 0.0;
		mainSprite.visible = true;
		FlxTween.tween(mainSprite, {"scale.x": 1.2, "scale.y": 1.2}, 5.0, {ease: FlxEase.linear});
		FlxTween.tween(mainSprite, {alpha: 1.0}, 2.5, {onComplete: onCompleteFadeIn});

		mainSound.play();
	}

	/** Called when the fade-in is finished. **/
	function onCompleteFadeIn(tween:FlxTween)
	{
		FlxTween.tween(mainSprite, {alpha: 0.0}, 2.5, {onComplete: onCompleteFadeOut});
	}

	/** Called when the fade-out is finished. **/
	function onCompleteFadeOut(tween:FlxTween)
	{
		mainSprite.visible = false;
		if (onComplete != null)
			onComplete();
	}
}
