package ui.map_hud;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import gbc.sound.AssetSound;
import gbc.sound.AssetSoundRegistry;

class MapHud extends FlxTypedGroup<FlxSprite>
{
	public var levelPanel(default, null):LevelPanel;

	/** Used to indicate to the player how to start the level. **/
	public var startLevelText:FlxText;

	public var inventory(default, null):Inventory;

	public var moneyIndicator(default, null):MoneyIndicator;

	var levelPanelAppearSound:AssetSound;

	public function new()
	{
		super();

		levelPanel = new LevelPanel();
		levelPanel.screenCenter();
		levelPanel.setPosition(levelPanel.x, 0.0);
		levelPanel.visible = false; // The level panel starts hidden by default
		levelPanelAppearSound = AssetSoundRegistry.getAsset("ui/map_hud/sounds/level_panel_appear");

		startLevelText = new FlxText(levelPanel.x, 0.0, levelPanel.width);
		startLevelText.setFormat("Edit Undo BRK", 20, FlxColor.WHITE, CENTER, SHADOW, FlxColor.BLACK);
		startLevelText.scrollFactor.set(0.0, 0.0);
		startLevelText.visible = false; // The start level text starts hidden by default
		add(startLevelText);

		inventory = new Inventory(6.0, FlxG.height - 48.0);
		add(inventory);

		moneyIndicator = new MoneyIndicator(0.0, 0.0);
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
}
