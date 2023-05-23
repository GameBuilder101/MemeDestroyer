package ui.shop_hud;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;

class ShopHud extends FlxTypedGroup<FlxSprite>
{
	public var inventory(default, null):Inventory;

	public var moneyIndicator(default, null):MoneyIndicator;

	public var dialogueBox(default, null):DialogueBox;

	public function new()
	{
		super();

		inventory = new Inventory(6.0, FlxG.height - 48.0);
		add(inventory);

		moneyIndicator = new MoneyIndicator(0.0, 0.0);
		moneyIndicator.setPosition(FlxG.width - moneyIndicator.width - 6.0, FlxG.height - moneyIndicator.height - 6.0);
		add(moneyIndicator);

		dialogueBox = new DialogueBox(0.0, 0.0);
		dialogueBox.screenCenter();
		dialogueBox.y = FlxG.height * 0.6;
		add(dialogueBox);
	}
}
