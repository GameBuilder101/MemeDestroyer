package ui.map_hud;

import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import gbc.graphics.AssetSprite;

class LevelPanel extends FlxSpriteGroup implements IIndicator
{
	/** The number of stars to display. **/
	static inline final NUM_STARS:Int = 5;

	var panel:AssetSprite;

	var label:FlxText;
	var highScore:FlxText;

	var stars:Array<AssetSprite> = [];

	var upperLine:AssetSprite;
	var lowerLine:AssetSprite;

	var indicatorColor:FlxColor = FlxColor.WHITE;

	public function new(x:Float = 0.0, y:Float = 0.0)
	{
		super(x, y);
		scrollFactor.set(0.0, 0.0);

		panel = new AssetSprite(0.0, 0.0, null, "ui/map_hud/sprites/level_panel");
		add(panel);

		upperLine = new AssetSprite(0.0, 8.0, "ui/_shared/sprites/title_line");
		add(upperLine);
		lowerLine = new AssetSprite(0.0, panel.height - 24.0, "ui/_shared/sprites/title_line");
		add(lowerLine);

		label = new FlxText(0.0, upperLine.height + 6.0, panel.width);
		label.setFormat("Edit Undo BRK", 36, FlxColor.WHITE, CENTER, SHADOW, FlxColor.BLACK);
		add(label);
		highScore = new FlxText(0.0, upperLine.height + 38.0, panel.width);
		highScore.setFormat("Edit Undo BRK", 20, FlxColor.WHITE, CENTER, SHADOW, FlxColor.BLACK);
		add(highScore);

		var star:AssetSprite;
		for (i in 0...NUM_STARS)
		{
			star = new AssetSprite(0.0, upperLine.height + 50.0, null, "ui/map_hud/sprites/level_star");
			star.x = x + (width / 2.0) - (NUM_STARS * star.width / 2.0) + (i * star.width);
			add(star);
			stars.push(star);
		}
	}

	public function setValues(current:Float, max:Float)
	{
		highScore.text = "High Score: " + cast(current, Int);
		// Make any stars in the score range active
		for (i in 0...stars.length)
		{
			if (i <= current / max * stars.length)
				stars[i].animation.play("active");
			else
				stars[i].animation.play("idle");
		}
		updateIndicatorColor();
	}

	public function setLabel(label:String)
	{
		this.label.text = label;
	}

	public function setIndicatorColor(color:FlxColor)
	{
		indicatorColor = color;
		updateIndicatorColor();
	}

	function updateIndicatorColor()
	{
		label.color = indicatorColor;
		highScore.color = indicatorColor;

		upperLine.color = indicatorColor;
		lowerLine.color = indicatorColor;

		for (star in stars)
		{
			if (star.animation.name == "idle")
				star.color = FlxColor.WHITE;
			else
				star.color = indicatorColor;
		}
	}
}
