package;

import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import gbc.graphics.AssetSprite;
import gbc.graphics.AssetSpriteRegistry;
import gbc.sound.AssetSound;
import gbc.sound.AssetSoundRegistry;

class TitleOverlay extends FlxSpriteGroup implements IOverlay
{
	var title:FlxText;
	var subtitle:FlxText;

	var upperLine:AssetSprite;
	var lowerLine:AssetSprite;

	/** A timer used to fade out after displaying. **/
	var fadeOutTimer:FlxTimer;

	var onComplete:Void->Void;

	public function new(x:Float = 0.0, y:Float = 0.0)
	{
		super(x, y);

		upperLine = new AssetSprite(0.0, 0.0, "ui/hud/sprites/title_line");
		upperLine.visible = false;
		add(upperLine);
		lowerLine = new AssetSprite(0.0, 80.0, "ui/hud/sprites/title_line");
		lowerLine.visible = false;
		add(lowerLine);

		title = new FlxText(0.0, upperLine.height + 28.0, upperLine.width, "Title");
		title.setFormat("Edit Undo BRK", 42, FlxColor.WHITE, CENTER, SHADOW, FlxColor.BLACK);
		title.visible = false;
		add(title);
		subtitle = new FlxText(0.0, upperLine.height + 2.0, upperLine.width, "Subtitle");
		subtitle.setFormat("Edit Undo BRK", 27, FlxColor.WHITE, CENTER, SHADOW, FlxColor.BLACK);
		subtitle.visible = false;
		add(subtitle);

		fadeOutTimer = new FlxTimer();
	}

	/** Requires args title:String, subtitle:String, and color:FlxColor. **/
	public function display(args:Dynamic, onComplete:Void->Void)
	{
		this.onComplete = onComplete;

		fadeOutTimer.cancel();

		FlxTween.cancelTweensOf(title);
		this.title.text = args.title;
		this.title.color = args.color;
		this.title.alpha = 0.0;
		this.title.visible = true;
		FlxTween.tween(this.title, {alpha: 1.0}, 1.5, {onComplete: onCompleteFadeIn});

		FlxTween.cancelTweensOf(subtitle);
		this.subtitle.text = args.subtitle;
		this.subtitle.color = args.color;
		this.subtitle.alpha = 0.0;
		this.subtitle.visible = true;
		FlxTween.tween(this.subtitle, {alpha: 1.0}, 1.5);

		FlxTween.cancelTweensOf(upperLine);
		upperLine.scale.x = 0.0;
		upperLine.color = args.color;
		upperLine.visible = true;
		FlxTween.tween(upperLine, {"scale.x": 1.0}, 1.5, {ease: FlxEase.expoOut});

		FlxTween.cancelTweensOf(lowerLine);
		lowerLine.scale.x = 0.0;
		lowerLine.color = args.color;
		lowerLine.visible = true;
		FlxTween.tween(lowerLine, {"scale.x": 1.0}, 1.5, {ease: FlxEase.expoOut});
	}

	/** Called when the fade-in is finished. **/
	function onCompleteFadeIn(tween:FlxTween)
	{
		fadeOutTimer.start(1.6, function(timer:FlxTimer)
		{
			// Fade out everything once the timer completes
			FlxTween.tween(title, {alpha: 0.0}, 0.5, {onComplete: onCompleteFadeOut});
			FlxTween.tween(subtitle, {alpha: 0.0}, 0.5);
			FlxTween.tween(upperLine, {alpha: 0.0}, 0.5);
			FlxTween.tween(lowerLine, {alpha: 0.0}, 0.5);
		});
	}

	/** Called when the fade-out is finished. **/
	function onCompleteFadeOut(tween:FlxTween)
	{
		title.visible = false;
		subtitle.visible = false;
		lowerLine.visible = false;
		upperLine.visible = false;
		if (onComplete != null)
			onComplete();
	}
}
