package gbc.sound;

import flixel.FlxG;
import flixel.tweens.FlxTween;

class MusicManager
{
	/** Transitions the music by fading in/out. **/
	public static function transition(music:AssetMusic, duration:Float)
	{
		if (duration <= 0.0)
		{
			music.play();
			return;
		}

		FlxG.sound.music.fadeOut(duration / 2.0, 0.0, function(tween:FlxTween)
		{
			music.play();
			FlxG.sound.music.fadeIn(duration / 2.0);
		});
	}

	public static function fadeOut(duration:Float)
	{
		FlxG.sound.music.fadeOut(duration);
	}
}
