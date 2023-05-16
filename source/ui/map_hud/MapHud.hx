package ui.map_hud;

import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.tweens.FlxTween;

class MapHud extends FlxTypedGroup<FlxSprite>
{
	public var levelPanel(default, null):LevelPanel;

	public function new()
	{
		super();

		levelPanel = new LevelPanel();
		levelPanel.screenCenter();
		levelPanel.setPosition(levelPanel.x, 0.0);
		levelPanel.visible = false; // The level panel starts hidden by default
		add(levelPanel);
	}

	/** Plays an animation to show the level panel. **/
	public function showLevelPanel()
	{
		levelPanel.visible = true;
		FlxTween.cancelTweensOf(levelPanel);
		FlxTween.linearMotion(levelPanel, levelPanel.x, -levelPanel.height, levelPanel.x, 0.0, 0.25);
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
