package ui;

import GameSaver;
import flixel.FlxG;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import gbc.graphics.TransitionDataRegistry;
import gbc.sound.AssetSound;
import gbc.sound.AssetSoundRegistry;
import gbc.sound.AssetSoundRegistry;
import gbc.sound.MusicManager;

/** A screen which can either save over or load from a saved game. **/
class SaveScreen extends FlxSpriteGroup
{
	public static inline final MAX_SLOTS:Int = 3;

	public var mode:SaveScreenMode;

	var label:FlxText;

	var slots:Array<SaveSlot> = [];

	var overwriteTargetID:Int;

	public var cancelOverwriteButton(default, null):StandardButton;
	public var confirmOverwriteButton(default, null):StandardButton;

	var saveSound:AssetSound;

	public function new(x:Float = 0.0, y:Float = 0.0, mode:SaveScreenMode)
	{
		super(x, y);
		scrollFactor.set(0.0, 0.0);

		this.mode = mode;

		label = new FlxText(0.0, 0.0, FlxG.width / 2.0);
		label.screenCenter();
		label.y = 16.0;
		label.setFormat("Edit Undo BRK", 24, FlxColor.WHITE, CENTER, SHADOW, FlxColor.BLACK);
		label.scrollFactor.set(0.0, 0.0);
		add(label);

		// Create save slots
		var data:GameSave;
		var slot:SaveSlot;
		for (i in 0...MAX_SLOTS)
		{
			data = GameSaver.instance.getSave(i);
			slot = new SaveSlot(0.0, 0.0, data, function()
			{
				switch (mode)
				{
					default:
						if (slots[i].data == null) // If there is already a save for this slot
							saveGame(i);
						else
							openOverwriteMenu(i);
					case LOAD:
						loadGame(i);
				}
			});
			slot.screenCenter();
			slot.y = i * 84.0 + 72.0;
			slots.push(slot);
			add(slot);
		}

		cancelOverwriteButton = new StandardButton(0.0, 0.0, "ui/_shared/sprites/button", "Nevermind", CENTER, openStandardMenu);
		cancelOverwriteButton.screenCenter();
		cancelOverwriteButton.y = 168.0;
		add(cancelOverwriteButton);
		confirmOverwriteButton = new StandardButton(cancelOverwriteButton.x, cancelOverwriteButton.y + cancelOverwriteButton.height + 8.0,
			"ui/_shared/sprites/button", "Overwrite", CENTER, function()
		{
			saveGame(overwriteTargetID);
			openStandardMenu();
		});
		confirmOverwriteButton.button.label.color = FlxColor.RED;
		add(confirmOverwriteButton);

		saveSound = AssetSoundRegistry.getAsset("ui/_shared/sounds/save_game");

		openStandardMenu();
	}

	function saveGame(id:Int)
	{
		GameSaver.instance.data.name = "Slot " + (id + 1); // Just name the save based on the slot number
		GameSaver.instance.saveGame(id);
		slots[id].loadFromData(GameSaver.instance.data); // Update the slot

		saveSound.play();
	}

	function loadGame(id:Int)
	{
		if (GameSaver.instance.getSave(id) == null)
			return;

		cast(FlxG.state, FlxTransitionableState).transOut = TransitionDataRegistry.getAsset("transitions/start_game");

		// Zoom in the camera while transitioning
		FlxTween.tween(FlxG.camera, {zoom: 1.5}, 2.0);

		MusicManager.fadeOut(0.0);
		AssetSoundRegistry.getAsset("ui/_shared/sounds/start_game").play();

		// Loads in data for the game save
		GameSaver.instance.loadGame(id);
		FlxG.switchState(new PlayState("levels/init"));
	}

	function openStandardMenu()
	{
		switch (mode)
		{
			default:
				label.text = "Choose a slot to save over";
			case LOAD:
				label.text = "Choose a game to load";
		}
		label.color = FlxColor.WHITE;

		for (slot in slots)
			slot.visible = true;

		cancelOverwriteButton.visible = false;
		confirmOverwriteButton.visible = false;
	}

	function openOverwriteMenu(targetID:Int)
	{
		overwriteTargetID = targetID;

		label.text = "Are you sure you want to overwrite this save?";
		label.color = FlxColor.RED;

		for (slot in slots)
			slot.visible = false;

		cancelOverwriteButton.visible = true;
		confirmOverwriteButton.visible = true;
	}
}

enum SaveScreenMode
{
	SAVE;
	LOAD;
}
