package;

import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel_fixed.ui.FlxBar;
import gbc.graphics.AssetSprite;
import gbc.graphics.AssetSpriteRegistry;
import gbc.sound.AssetSound;
import gbc.sound.AssetSoundRegistry;

class TitleOverlay extends FlxSpriteGroup
{
	var title:FlxText;
	var subtitle:FlxText;

	var upperLine:AssetSprite;
	var lowerLine:AssetSprite;

	/** A timer used to fade out after displaying. **/
	var fadeOutTimer:FlxTimer;

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

	/** Plays an animation on the overlay. **/
	public function display(title:String, subtitle:String, color:FlxColor)
	{
		fadeOutTimer.cancel();

		FlxTween.cancelTweensOf(title);
		this.title.text = title;
		this.title.color = color;
		this.title.color.alpha = 0;
		this.title.visible = true;
		FlxTween.color(this.title, 1.5, this.title.color, color, {onComplete: onCompleteFadeIn});

		FlxTween.cancelTweensOf(subtitle);
		this.subtitle.text = subtitle;
		this.subtitle.color = color;
		this.subtitle.color.alpha = 0;
		this.subtitle.visible = true;
		FlxTween.color(this.subtitle, 1.5, this.subtitle.color, color);

		FlxTween.cancelTweensOf(upperLine);
		upperLine.scale.x = 0.0;
		upperLine.color = color;
		upperLine.visible = true;
		FlxTween.tween(upperLine, {"scale.x": 1.0}, 1.5);

		FlxTween.cancelTweensOf(lowerLine);
		lowerLine.scale.x = 0.0;
		lowerLine.color = color;
		lowerLine.visible = true;
		FlxTween.tween(lowerLine, {"scale.x": 1.0}, 1.5);
	}

	/** Called when the fade-in is finished. **/
	function onCompleteFadeIn(tween:FlxTween)
	{
		fadeOutTimer.start(2.0, function(timer:FlxTimer)
		{
			// Fade out everything once the timer completes
			FlxTween.color(title, 1.5, title.color, FlxColor.fromRGB(title.color.red, title.color.green, title.color.blue, 0),
				{onComplete: onCompleteFadeOut});
			FlxTween.color(subtitle, 1.5, subtitle.color, FlxColor.fromRGB(subtitle.color.red, subtitle.color.green, subtitle.color.blue, 0));
			FlxTween.color(upperLine, 1.5, upperLine.color, FlxColor.fromRGB(upperLine.color.red, upperLine.color.green, upperLine.color.blue, 0));
			FlxTween.color(lowerLine, 1.5, lowerLine.color, FlxColor.fromRGB(lowerLine.color.red, lowerLine.color.green, lowerLine.color.blue, 0));
		});
	}

	/** Called when the fade-out is finished. **/
	function onCompleteFadeOut(tween:FlxTween)
	{
		title.visible = false;
		subtitle.visible = false;
		lowerLine.visible = false;
		upperLine.visible = false;
	}
}
