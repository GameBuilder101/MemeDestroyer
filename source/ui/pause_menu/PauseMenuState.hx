package ui.pause_menu;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.addons.transition.FlxTransitionableState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import gbc.graphics.AssetSprite;
import gbc.sound.AssetSound;
import gbc.sound.AssetSoundRegistry;
import gbc.sound.MusicManager;
import ui.title.TitleState;

class PauseMenuState extends FlxSubState
{
	var background:FlxSprite;
	var sketch1:AssetSprite;
	var sketch2:AssetSprite;
	var label:FlxText;

	public var backButton(default, null):StandardButton;
	public var saveButton(default, null):StandardButton;
	public var quitButton(default, null):StandardButton;
	public var globalVolumeSlider(default, null):GlobalVolumeSlider;

	public var cancelQuitButton(default, null):StandardButton;
	public var confirmQuitButton(default, null):StandardButton;

	public var saveScreen(default, null):SaveScreen;
	public var cancelSaveButton(default, null):StandardButton;

	var justOpened:Bool = true;

	override function create()
	{
		super.create();

		background = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		background.scrollFactor.set(0.0, 0.0);
		background.alpha = 0.8;
		add(background);

		sketch1 = new AssetSprite(0.0, 0.0, null, "ui/pause_menu/sprites/sketch");
		sketch1.screenCenter();
		sketch1.x = 8.0;
		sketch1.scrollFactor.set(0.0, 0.0);
		sketch1.alpha = 0.2;
		add(sketch1);

		// Set the random sketch graphic by choosing a random frame of animation
		var sketch1Index:Int = Std.int(Math.random() * sketch1.animation.numFrames);
		sketch1.animation.frameIndex = sketch1Index;

		sketch2 = new AssetSprite(0.0, 0.0, null, "ui/pause_menu/sprites/sketch");
		sketch2.screenCenter();
		sketch2.x = FlxG.width - 8.0 - sketch2.width;
		sketch2.scrollFactor.set(0.0, 0.0);
		sketch2.alpha = 0.2;
		add(sketch2);

		// Set the other sketch graphic by choosing a frame which is different from the first sketch
		var sketch2Index:Int = -1;
		while (sketch2Index < 0 || sketch2Index == sketch1Index)
			sketch2Index = Std.int(Math.random() * sketch2.animation.numFrames);
		sketch2.animation.frameIndex = sketch2Index;

		label = new FlxText(0.0, 0.0, FlxG.width / 2.0);
		label.screenCenter();
		label.y = 64.0;
		label.setFormat("Edit Undo BRK", 24, FlxColor.WHITE, CENTER, SHADOW, FlxColor.BLACK);
		label.scrollFactor.set(0.0, 0.0);
		add(label);

		backButton = new StandardButton(0.0, 0.0, "ui/_shared/sprites/button", "Back", CENTER, close);
		backButton.screenCenter();
		backButton.y = 128.0;
		add(backButton);
		saveButton = new StandardButton(backButton.x, backButton.y + backButton.height + 8.0, "ui/_shared/sprites/button", "Save Game", CENTER, openSaveMenu);
		add(saveButton);
		quitButton = new StandardButton(saveButton.x, saveButton.y + saveButton.height + 8.0, "ui/_shared/sprites/button", "Quit to Title", CENTER,
			openQuitMenu);
		add(quitButton);
		globalVolumeSlider = new GlobalVolumeSlider();
		globalVolumeSlider.screenCenter();
		globalVolumeSlider.y = quitButton.y + quitButton.height + 8.0;
		add(globalVolumeSlider);

		cancelQuitButton = new StandardButton(backButton.x, saveButton.y, "ui/_shared/sprites/button", "Nevermind", CENTER, openStandardMenu);
		add(cancelQuitButton);
		confirmQuitButton = new StandardButton(cancelQuitButton.x, cancelQuitButton.y + cancelQuitButton.height + 8.0, "ui/_shared/sprites/button",
			"Quit to Title", CENTER, function()
		{
			MusicManager.fadeOut(cast(FlxG.state, FlxTransitionableState).transOut.duration);
			FlxG.switchState(new TitleState());
		});
		confirmQuitButton.button.label.color = FlxColor.RED;
		add(confirmQuitButton);

		cancelSaveButton = new StandardButton(backButton.x, FlxG.height - 48.0, "ui/_shared/sprites/button", "Back", CENTER, openStandardMenu);
		add(cancelSaveButton);

		AssetSoundRegistry.getAsset("ui/pause_menu/sounds/open").play();
		openStandardMenu();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		if (!justOpened && Controls.pause.check())
			close();
		justOpened = false;
	}

	override function close()
	{
		AssetSoundRegistry.getAsset("ui/pause_menu/sounds/close").play();
		super.close();
	}

	function openStandardMenu()
	{
		label.text = "Paused";
		label.color = FlxColor.WHITE;

		backButton.visible = true;
		saveButton.visible = true;
		quitButton.visible = true;
		globalVolumeSlider.visible = true;

		cancelQuitButton.visible = false;
		confirmQuitButton.visible = false;

		if (saveScreen != null)
		{
			remove(saveScreen, true);
			saveScreen.destroy();
			saveScreen = null;
		}
		cancelSaveButton.visible = false;
	}

	function openSaveMenu()
	{
		label.text = "";

		backButton.visible = false;
		saveButton.visible = false;
		quitButton.visible = false;
		globalVolumeSlider.visible = false;

		cancelQuitButton.visible = false;
		confirmQuitButton.visible = false;

		saveScreen = new SaveScreen(0.0, 0.0, SAVE);
		add(saveScreen);
		cancelSaveButton.visible = true;
	}

	function openQuitMenu()
	{
		label.text = "Are you sure you want to quit? All unsaved progress will be lost!";
		label.color = FlxColor.RED;

		backButton.visible = false;
		saveButton.visible = false;
		quitButton.visible = false;
		globalVolumeSlider.visible = false;

		cancelQuitButton.visible = true;
		confirmQuitButton.visible = true;

		if (saveScreen != null)
		{
			remove(saveScreen, true);
			saveScreen.destroy();
			saveScreen = null;
		}
		cancelSaveButton.visible = false;
	}
}
