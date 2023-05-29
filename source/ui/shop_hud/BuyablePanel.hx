package ui.shop_hud;

import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import gbc.graphics.AssetSprite;

/** A panel used to display information about a buyable entity. **/
class BuyablePanel extends FlxSpriteGroup implements IIndicator
{
	public var panel(default, null):AssetSprite;

	var label:FlxText;
	var description:FlxText;

	var cost:FlxText;
	var moneyIcon:AssetSprite;

	var indicatorColor:FlxColor = FlxColor.WHITE;

	public function new(x:Float = 0.0, y:Float = 0.0)
	{
		super(x, y);
		scrollFactor.set(0.0, 0.0);

		panel = new AssetSprite(0.0, 0.0, null, "ui/shop_hud/sprites/buyable_panel");
		add(panel);

		label = new FlxText(12.0, 14.0, panel.width - 24.0);
		label.setFormat("Edit Undo BRK", 26, FlxColor.WHITE, LEFT, SHADOW, FlxColor.BLACK);
		add(label);
		description = new FlxText(12.0, 44.0, panel.width - 24.0);
		description.setFormat("Edit Undo BRK", 18, FlxColor.WHITE, LEFT, SHADOW, FlxColor.BLACK);
		add(description);

		moneyIcon = new AssetSprite(0.0, 12.0, null, "ui/_shared/sprites/money_icon");
		moneyIcon.x = panel.width - moneyIcon.width - 8.0;
		add(moneyIcon);
		cost = new FlxText(12.0, 14.0, panel.width - moneyIcon.width - 24.0);
		cost.setFormat("Edit Undo BRK", 26, FlxColor.WHITE, RIGHT, SHADOW, FlxColor.BLACK);
		add(cost);
	}

	public function setValues(current:Float, max:Float)
	{
		cost.text = current + "";
	}

	public function setLabel(label:String)
	{
		this.label.text = label;
	}

	public function setIndicatorColor(color:FlxColor)
	{
		indicatorColor = color;

		label.color = color;
		description.color = color;

		cost.color = color;
		moneyIcon.color = color;
	}

	public function getIndicatorColor():FlxColor
	{
		return indicatorColor;
	}

	public function setDescription(description:String)
	{
		this.description.text = description;
	}
}
