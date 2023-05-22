package ui;

import flixel.FlxG;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import gbc.graphics.AssetSprite;

class DialogueBox extends FlxSpriteGroup
{
	var background:AssetSprite;
	var portrait:AssetSprite;
	var name:FlxText;
	var dialogue:FlxText;

	public function new(x:Float = 0.0, y:Float = 0.0)
	{
		super(x, y);
		scrollFactor.set(0.0, 0.0);

		background = new AssetSprite(0.0, FlxG.height * 0.7, null, "ui/_shared/sprites/dialogue_background");
		add(background);

		portrait = new AssetSprite(FlxG.width / 2.0 - 256.0, background.y + 8.0, null, "ui/_shared/sprites/shopkeep_portrait");
		add(portrait);

		name = new FlxText(portrait.x + 8.0, portrait.y, 504.0 - portrait.width);
		name.setFormat("Edit Undo BRK", 24, FlxColor.WHITE, LEFT, SHADOW, FlxColor.BLACK);
		add(name);

		dialogue = new FlxText(portrait.x + 8.0, portrait.y + 12.0, 504.0 - portrait.width);
		dialogue.setFormat("Edit Undo BRK", 20, FlxColor.WHITE, LEFT, SHADOW, FlxColor.BLACK);
		add(dialogue);
	}
}
