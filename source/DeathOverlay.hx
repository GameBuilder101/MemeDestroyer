package;

import flixel.group.FlxSpriteGroup;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import gbc.graphics.AssetSprite;
import gbc.sound.AssetSound;
import gbc.sound.AssetSoundRegistry;

class DeathOverlay extends FlxSpriteGroup
{
	var mainSprite:AssetSprite;

	var mainSound:AssetSound;

	public function new(x:Float = 0.0, y:Float = 0.0)
	{
		super(x, y);

		mainSprite = new AssetSprite(0.0, 0.0, null, "ui/hud/sprites/death_overlay");
		add(mainSprite);
		mainSprite.visible = false;

		mainSound = AssetSoundRegistry.getAsset("ui/hud/sounds/death_overlay");
	}

	/** Plays an animation on the overlay. **/
	public function display()
	{
		FlxTween.cancelTweensOf(mainSprite);
		mainSprite.scale.set(1.0, 1.0);
		mainSprite.color = FlxColor.TRANSPARENT;
		mainSprite.visible = true;
		FlxTween.tween(mainSprite, {"scale.x": 1.2, "scale.y": 1.2}, 5.0, {ease: FlxEase.linear});
		FlxTween.color(mainSprite, 2.5, FlxColor.TRANSPARENT, FlxColor.WHITE, {onComplete: onCompleteFadeIn});

		mainSound.play();
	}

	/** Called when the fade-in is finished. **/
	function onCompleteFadeIn(tween:FlxTween)
	{
		FlxTween.color(mainSprite, 2.5, FlxColor.WHITE, FlxColor.TRANSPARENT, {onComplete: onCompleteFadeOut});
	}

	/** Called when the fade-out is finished. **/
	function onCompleteFadeOut(tween:FlxTween)
	{
		mainSprite.visible = false;
	}
}
