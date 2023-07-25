package ui.map_hud;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import gbc.sound.AssetSound;
import gbc.sound.AssetSoundRegistry;

class MapHud extends FlxTypedGroup<FlxSprite>
{
	public var levelPanel(default, null):LevelPanel;

	/** Used to indicate to the player how to start the level. **/
	public var startLevelText:FlxText;

	/** Used to display an error message if the player cannot move to a spot. **/
	public var messageText:FlxText;

	public var displayingMessage(default, null):Bool;

	var messageTimer:FlxTimer;

	/** How long to wait after displaying the message text to close it. **/
	static inline final MESSAGE_CLOSE_DELAY:Float = 1.0;

	public var inventory(default, null):Inventory;

	public var moneyIndicator(default, null):IconIndicator;

	var levelPanelAppearSound:AssetSound;

	public function new()
	{
		super();

		levelPanel = new LevelPanel();
		levelPanel.screenCenter();
		levelPanel.setPosition(levelPanel.x, -levelPanel.height);
		levelPanel.visible = false; // The level panel starts hidden by default
		levelPanelAppearSound = AssetSoundRegistry.getAsset("ui/_shared/sounds/panel_appear");

		startLevelText = new FlxText(levelPanel.x, 0.0, levelPanel.width);
		startLevelText.setFormat("Edit Undo BRK", 20, FlxColor.WHITE, CENTER, SHADOW, FlxColor.BLACK);
		startLevelText.scrollFactor.set(0.0, 0.0);
		startLevelText.visible = false; // The start level text starts hidden by default
		add(startLevelText);

		messageText = new FlxText(0.0, FlxG.height - 64.0, FlxG.width);
		messageText.setFormat("Edit Undo BRK", 20, FlxColor.RED, CENTER, SHADOW, FlxColor.BLACK);
		messageText.scrollFactor.set(0.0, 0.0);
		messageText.alpha = 0.0;
		add(messageText);
		messageTimer = new FlxTimer();

		inventory = new Inventory(6.0, FlxG.height - 48.0);
		add(inventory);

		moneyIndicator = new IconIndicator(0.0, 0.0, "ui/_shared/sprites/money_icon", "ui/_shared/sounds/error");
		moneyIndicator.setPosition(FlxG.width - moneyIndicator.width - 6.0, FlxG.height - moneyIndicator.height - 6.0);
		add(moneyIndicator);

		add(levelPanel);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		startLevelText.y = levelPanel.y + levelPanel.panel.height;
		startLevelText.color = levelPanel.getIndicatorColor();
	}

	/** Plays an animation to show the level panel. **/
	public function showLevelPanel()
	{
		levelPanel.visible = true;
		FlxTween.cancelTweensOf(levelPanel);
		FlxTween.linearMotion(levelPanel, levelPanel.x, -levelPanel.height, levelPanel.x, 0.0, 0.25);

		levelPanelAppearSound.play();
	}

	/** Plays an animation to hide the level panel. **/
	public function hideLevelPanel()
	{
		FlxTween.cancelTweensOf(levelPanel);
		FlxTween.linearMotion(levelPanel, levelPanel.x, 0.0, levelPanel.x, -levelPanel.height, 0.25, true, {
			onComplete: function(tween:FlxTween)
			{
				levelPanel.visible = false;
			}
		});
	}

	public function displayMessage(message:String)
	{
		displayingMessage = true;

		FlxTween.cancelTweensOf(messageText);
		messageText.text = message;
		messageText.alpha = 1.0;
		messageTimer.start(MESSAGE_CLOSE_DELAY, function(timer:FlxTimer)
		{
			FlxTween.tween(messageText, {alpha: 0.0}, 1.0, {
				onComplete: function(tween:FlxTween)
				{
					displayingMessage = false;
				}
			});
		});
	}
}
