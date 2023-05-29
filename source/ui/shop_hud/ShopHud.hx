package ui.shop_hud;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.tweens.FlxTween;
import gbc.sound.AssetSound;
import gbc.sound.AssetSoundRegistry;
import ui.shop_hud.BuyablePanel;

class ShopHud extends FlxTypedGroup<FlxSprite>
{
	public var inventory(default, null):Inventory;

	public var moneyIndicator(default, null):IconIndicator;

	public var buyablePanel(default, null):BuyablePanel;

	var buyablePanelAppearSound:AssetSound;

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

		moneyIndicator = new IconIndicator(0.0, 0.0, "ui/_shared/sprites/money_icon", "ui/_shared/sounds/error");
		moneyIndicator.setPosition(FlxG.width - moneyIndicator.width - 6.0, FlxG.height - moneyIndicator.height - 6.0);
		add(moneyIndicator);

		buyablePanel = new BuyablePanel();
		buyablePanel.screenCenter();
		buyablePanel.setPosition(buyablePanel.x, -buyablePanel.height);
		buyablePanel.visible = false; // The buyable panel starts hidden by default
		buyablePanelAppearSound = AssetSoundRegistry.getAsset("ui/_shared/sounds/panel_appear");
		add(buyablePanel);
	}

	/** Plays an animation to show the buyable panel. **/
	public function showBuyablePanel()
	{
		buyablePanel.visible = true;
		FlxTween.cancelTweensOf(buyablePanel);
		FlxTween.linearMotion(buyablePanel, buyablePanel.x, -buyablePanel.height, buyablePanel.x, 0.0, 0.25);

		buyablePanelAppearSound.play();
	}

	/** Plays an animation to hide the buyable panel. **/
	public function hideBuyablePanel()
	{
		FlxTween.cancelTweensOf(buyablePanel);
		FlxTween.linearMotion(buyablePanel, buyablePanel.x, 0.0, buyablePanel.x, -buyablePanel.height, 0.25, true, {
			onComplete: function(tween:FlxTween)
			{
				buyablePanel.visible = false;
			}
		});
	}
}
