package;

import flixel.FlxG;
import flixel.group.FlxSpriteGroup;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import gbc.graphics.AssetSprite;
import gbc.sound.AssetSound;
import gbc.sound.AssetSoundRegistry;

/** A countdown overlay that plays a Mortal-Combat-esque animation. **/
class CountdownOverlay extends FlxSpriteGroup implements IOverlay
{
	public static final SHAKE_INTENSITY = 3.0;

	var sprites:Array<AssetSprite> = [];
	var sounds:Array<AssetSound> = [];

	var currentSprite:Int = -1;

	var delayDuration:Float;

	/** A timer used to delay until the next countdown step. **/
	var delayTimer:FlxTimer;

	var onComplete:Void->Void;

	public function new(x:Float = 0.0, y:Float = 0.0, delayDuration:Float, spriteIDs:Array<String>, animations:Array<String>, soundIDs:Array<String>)
	{
		super(x, y);

		// Create all needed sprites
		var i:Int = 0;
		var sprite:AssetSprite;
		for (spriteID in spriteIDs)
		{
			sprite = new AssetSprite(0.0, 0.0, null, spriteID);
			sprite.visible = false;
			if (i < animations.length) // Play the idle animations for each sprite
				sprite.animation.play(animations[i]);
			sprites.push(sprite);
			add(sprite);

			i++;
		}

		// Create all needed sounds
		for (soundID in soundIDs)
			sounds.push(AssetSoundRegistry.getAsset(soundID));

		this.delayDuration = delayDuration;
		delayTimer = new FlxTimer();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		if (currentSprite < 0) // If not animating
			return;

		// Randomly shake the current sprite, making sure it doesn't go too far
		var sprite:AssetSprite = sprites[currentSprite];
		sprite.x += FlxG.random.float(-SHAKE_INTENSITY * sprite.width, SHAKE_INTENSITY * sprite.width) * elapsed;
		if (sprite.x < -sprite.width / 10.0 + x)
			sprite.x = -sprite.width / 10.0 + x;
		else if (sprite.x > sprite.width / 10.0 + x)
			sprite.x = sprite.width / 10.0 + x;
		sprite.y += FlxG.random.float(-SHAKE_INTENSITY * sprite.height, SHAKE_INTENSITY * sprite.height) * elapsed;
		if (sprite.y < -sprite.height / 10.0 + y)
			sprite.y = -sprite.height / 10.0 + y;
		else if (sprite.y > sprite.height / 10.0 + y)
			sprite.y = sprite.height / 10.0 + y;
	}

	public function display(args:Dynamic, onComplete:Void->Void)
	{
		this.onComplete = onComplete;

		if (currentSprite >= 0) // Hide the current sprite if it is already animating
		{
			FlxTween.cancelTweensOf(sprites[currentSprite]);
			sprites[currentSprite].visible = false;
		}
		delayTimer.cancel();

		animateSprite(0);
	}

	/** Either animates one of the countdown sprites or stops the countdown if greater than the sprite count. **/
	function animateSprite(index:Int)
	{
		currentSprite = index;

		FlxTween.cancelTweensOf(sprites[index]);
		sprites[index].scale.set(1.5, 1.5);
		sprites[index].alpha = 1.0;
		sprites[index].setPosition(x, y);
		sprites[index].visible = true;
		FlxTween.tween(sprites[index], {"scale.x": 1.0, "scale.y": 1.0}, 0.5, {ease: FlxEase.expoOut, onComplete: onCompleteAnimateSprite});

		if (index < sounds.length)
			sounds[index].play();
	}

	function onCompleteAnimateSprite(tween:FlxTween)
	{
		delayTimer.start(delayDuration, function(timer:FlxTimer)
		{
			if (currentSprite == sprites.length - 1) // If finished, stop animating
			{
				// Fade out the final sprite
				FlxTween.tween(sprites[currentSprite], {alpha: 0.0}, 0.5, {
					onComplete: function(tween:FlxTween)
					{
						sprites[currentSprite].visible = false;
						currentSprite = -1;
						if (onComplete != null)
							onComplete();
					}
				});
			}
			else
			{
				sprites[currentSprite].visible = false;
				animateSprite(currentSprite + 1);
			}
		});
	}
}
