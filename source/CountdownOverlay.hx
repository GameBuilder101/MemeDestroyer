package;

import flixel.group.FlxSpriteGroup;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import gbc.graphics.AssetSprite;
import gbc.sound.AssetSound;
import gbc.sound.AssetSoundRegistry;

/** A countdown overlay that plays a Mortal-Combat-esque animation. **/
class CountdownOverlay extends FlxSpriteGroup
{
	var sprites:Array<AssetSprite>;
	var sounds:Array<AssetSound>;

	public function new(x:Float = 0.0, y:Float = 0.0, spriteIDs:Array<String>, soundIDs:Array<String>)
	{
		super(x, y);

		for (spriteID in spriteIDs) {}

		mainSprite = new AssetSprite(0.0, 0.0, null, spriteID);
		add(mainSprite);
		mainSprite.visible = false;

		mainSound = AssetSoundRegistry.getAsset(soundID);
	}
}
