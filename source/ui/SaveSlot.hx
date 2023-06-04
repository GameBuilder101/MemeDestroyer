package ui;

import GameSaver;
import entity.Entity;
import entity.EntityRegistry;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import gbc.graphics.AssetSprite;

class SaveSlot extends FlxSpriteGroup
{
	/** The currently-displayed save data. **/
	public var data(default, null):GameSave;

	public var button(default, null):StandardButton;

	var name:FlxText;
	var date:FlxText;

	var player:AssetSprite;
	var playerHands:AssetSprite;

	public function new(x:Float = 0.0, y:Float = 0.0, data:GameSave = null, onClick:Void->Void = null)
	{
		super(x, y);
		scrollFactor.set(0.0, 0.0);

		button = new StandardButton(0.0, 0.0, "ui/_shared/sprites/save_slot", "", CENTER, onClick);
		add(button);

		name = new FlxText(12.0, 14.0, button.width - 24.0);
		name.setFormat("Edit Undo BRK", 24, FlxColor.WHITE, LEFT, SHADOW, FlxColor.BLACK);
		add(name);
		date = new FlxText(12.0, 44.0, button.width - 24.0);
		date.setFormat("Edit Undo BRK", 18, FlxColor.WHITE, LEFT, SHADOW, FlxColor.BLACK);
		add(date);

		var playerEntity:EntityData = EntityRegistry.getAsset("entities/player");
		player = new AssetSprite(0.0, 0.0, null, playerEntity.spriteID);
		if (playerEntity.hitboxSize != null)
		{
			player.width = playerEntity.hitboxSize[0];
			player.height = playerEntity.hitboxSize[1];
		}
		player.setPosition(button.width - player.width - 24.0, (button.height - player.height) / 2.0);
		add(player);

		playerHands = new AssetSprite(player.x, player.y);
		add(playerHands);

		loadFromData(data);
	}

	/** Displays the data from the given game save. **/
	public function loadFromData(data:GameSave)
	{
		this.data = data;

		if (data == null)
		{
			button.animationPrefix = "empty_";

			name.text = "";
			date.text = "";

			player.alpha = 0.0; // Use alpha instead because hiding/unhiding the slot will mess up player sprite visibility
			playerHands.alpha = 0.0;
			return;
		}

		button.animationPrefix = "";

		name.text = data.name;
		date.text = data.date;

		player.alpha = 1.0; // Use alpha instead because hiding/unhiding the slot will mess up player sprite visibility
		playerHands.alpha = 1.0;
		playerHands.loadFromID("entities/player/sprites/hands");
		// Set the hands graphic to display the player's first equipped item in the save
		for (gameData in data.data)
		{
			if (gameData.key != "playerInventory")
				continue;
			if (gameData.value[0] == "") // If no item is equipped in the first slot
				break;

			// Get the entity data
			var item:EntityData = EntityRegistry.getAsset(gameData.value[0]);
			// Find the held sprite ID variable
			for (variable in item.variables)
			{
				if (variable.name != "heldSpriteID")
					continue;
				playerHands.loadFromID(variable.value);
			}
			break;
		}
	}
}
