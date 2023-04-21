package ui.hud;

import flixel.FlxG;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import gbc.graphics.AssetSprite;

class TitleOverlay extends FlxSpriteGroup implements IOverlay
{
	var title:FlxText;
	var subtitle:FlxText;

	var upperLine:AssetSprite;
	var lowerLine:AssetSprite;

	/** The animation style. **/
	var style:String;

	/** A timer used to fade out after displaying. **/
	var fadeOutTimer:FlxTimer;

	var onComplete:Void->Void;

	public function new(x:Float = 0.0, y:Float = 0.0)
	{
		super(x, y);
		scrollFactor.set(0.0, 0.0);

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

	/** Requires args title:String, subtitle:String, color:FlxColor, and style:String. **/
	public function display(args:Dynamic, onComplete:Void->Void)
	{
		this.onComplete = onComplete;
		this.style = args.style;

		fadeOutTimer.cancel();

		var duration:Float = 1.5;
		if (style == "fast")
			duration = 0.75;

		FlxTween.cancelTweensOf(title);
		this.title.text = args.title;
		this.title.color = args.color;
		this.title.alpha = 0.0;
		this.title.visible = true;
		FlxTween.tween(this.title, {alpha: 1.0}, duration, {onComplete: onCompleteFadeIn});

		FlxTween.cancelTweensOf(subtitle);
		this.subtitle.text = args.subtitle;
		this.subtitle.color = args.color;
		this.subtitle.alpha = 0.0;
		this.subtitle.visible = true;
		FlxTween.tween(this.subtitle, {alpha: 1.0}, duration);

		FlxTween.cancelTweensOf(upperLine);
		upperLine.color = args.color;
		upperLine.alpha = 1.0;
		upperLine.visible = true;
		if (style == "fast")
		{
			upperLine.x = -upperLine.width;
			upperLine.scale.x = 1.0;
			FlxTween.tween(upperLine, {x: x}, duration, {ease: FlxEase.expoOut});
		}
		else
		{
			upperLine.x = x;
			upperLine.scale.x = 0.0;
			FlxTween.tween(upperLine, {"scale.x": 1.0}, duration, {ease: FlxEase.expoOut});
		}

		FlxTween.cancelTweensOf(lowerLine);
		lowerLine.color = args.color;
		lowerLine.alpha = 1.0;
		lowerLine.visible = true;
		if (style == "fast")
		{
			lowerLine.x = FlxG.width;
			lowerLine.scale.x = 1.0;
			FlxTween.tween(lowerLine, {x: x}, duration, {ease: FlxEase.expoOut});
		}
		else
		{
			lowerLine.x = x;
			lowerLine.scale.x = 0.0;
			FlxTween.tween(lowerLine, {"scale.x": 1.0}, duration, {ease: FlxEase.expoOut});
		}
	}

	/** Called when the fade-in is finished. **/
	function onCompleteFadeIn(tween:FlxTween)
	{
		var duration:Float = 2.2;
		if (style == "fast")
			duration = 1.0;

		fadeOutTimer.start(duration, function(timer:FlxTimer)
		{
			// Fade out everything once the timer completes
			FlxTween.tween(title, {alpha: 0.0}, 0.5, {onComplete: onCompleteFadeOut});
			FlxTween.tween(subtitle, {alpha: 0.0}, 0.5);
			if (style == "fast")
			{
				FlxTween.tween(upperLine, {x: FlxG.width}, 0.5, {ease: FlxEase.expoIn});
				FlxTween.tween(lowerLine, {x: -lowerLine.width}, 0.5, {ease: FlxEase.expoIn});
			}
			else
			{
				FlxTween.tween(upperLine, {alpha: 0.0}, 0.5);
				FlxTween.tween(lowerLine, {alpha: 0.0}, 0.5);
			}
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
