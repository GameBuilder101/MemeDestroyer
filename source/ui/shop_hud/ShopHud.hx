package ui.shop_hud;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.tweens.FlxTween;
import gbc.sound.AssetSound;
import gbc.sound.AssetSoundRegistry;
import ui.shop_hud.ItemPanel;

class ShopHud extends FlxTypedGroup<FlxSprite>
{
	public var inventory(default, null):Inventory;

	public var moneyIndicator(default, null):MoneyIndicator;

	public var itemPanel(default, null):ItemPanel;

	var itemPanelAppearSound:AssetSound;

	public var dialogueBox(default, null):DialogueBox;

	public function new()
	{
		super();

		dialogueBox = new DialogueBox(0.0, 0.0);
		dialogueBox.screenCenter();
		dialogueBox.y = FlxG.height * 0.6;
		add(dialogueBox);

		inventory = new Inventory(6.0, FlxG.height - 48.0);
		add(inventory);

		moneyIndicator = new MoneyIndicator(0.0, 0.0);
		moneyIndicator.setPosition(FlxG.width - moneyIndicator.width - 6.0, FlxG.height - moneyIndicator.height - 6.0);
		add(moneyIndicator);

		itemPanel = new ItemPanel();
		itemPanel.screenCenter();
		itemPanel.setPosition(itemPanel.x, 0.0);
		itemPanel.visible = false; // The item panel starts hidden by default
		itemPanelAppearSound = AssetSoundRegistry.getAsset("ui/_shared/sounds/panel_appear");
		add(itemPanel);
	}

	/** Plays an animation to show the item panel. **/
	public function showItemPanel()
	{
		itemPanel.visible = true;
		FlxTween.cancelTweensOf(itemPanel);
		FlxTween.linearMotion(itemPanel, itemPanel.x, -itemPanel.height, itemPanel.x, 0.0, 0.25);

		itemPanelAppearSound.play();
	}

	/** Plays an animation to hide the item panel. **/
	public function hideItemPanel()
	{
		FlxTween.cancelTweensOf(itemPanel);
		FlxTween.linearMotion(itemPanel, itemPanel.x, 0.0, itemPanel.x, -itemPanel.height, 0.25, true, {
			onComplete: function(tween:FlxTween)
			{
				itemPanel.visible = false;
			}
		});
	}
}
