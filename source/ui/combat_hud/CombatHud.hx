package ui.combat_hud;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import gbc.graphics.AssetSprite;

class CombatHud extends FlxTypedGroup<FlxSprite>
{
	/** Health indicator for player. **/
	public var playerHealth(default, null):HealthNotches;

	/** Health indicator for bosses. **/
	public var bossHealth(default, null):HealthBar;

	public var inventory(default, null):Inventory;

	public var ammoIndicator(default, null):IconIndicator;

	public var dialogueBox(default, null):DialogueBox;

	public var titleOverlay(default, null):TitleOverlay;

	public var countdownOverlay(default, null):CountdownOverlay;

	public var deathOverlay(default, null):NotificationOverlay;

	public var flashOverlay(default, null):AssetSprite;

	public function new()
	{
		super();

		// Add the flash overlay
		flashOverlay = new AssetSprite(0.0, 0.0, null, "ui/combat_hud/sprites/flash_overlay");
		flashOverlay.alpha = 0.0;
		flashOverlay.visible = false;
		add(flashOverlay);

		// Add the dialogue box
		dialogueBox = new DialogueBox(0.0, 0.0);
		dialogueBox.screenCenter();
		dialogueBox.y = FlxG.height * 0.6;
		add(dialogueBox);

		// Add the player health
		playerHealth = new HealthNotches();
		playerHealth.setPosition(FlxG.width / 2.0, -20.0);
		playerHealth.visible = false; // The player health starts hidden by default
		add(playerHealth);

		// Add the boss health
		bossHealth = new HealthBar();
		bossHealth.screenCenter();
		bossHealth.y = FlxG.height;
		bossHealth.visible = false; // The boss health starts hidden by default
		add(bossHealth);

		// Add the inventory
		inventory = new Inventory(6.0, FlxG.height - 48.0);
		add(inventory);

		// Add the ammo indicator
		ammoIndicator = new IconIndicator(0.0, 0.0, "ui/combat_hud/sprites/ammo_icon", "ui/_shared/sounds/error");
		ammoIndicator.setPosition(FlxG.width - ammoIndicator.width - 6.0, FlxG.height - ammoIndicator.height - 6.0);
		add(ammoIndicator);

		// Add the title overlay
		titleOverlay = new TitleOverlay(0.0, 0.0);
		titleOverlay.screenCenter();
		add(titleOverlay);

		// Add the countdown overlay
		countdownOverlay = new CountdownOverlay(0.0, 0.0, 0.4, [
			"ui/combat_hud/sprites/countdown_overlay",
			"ui/combat_hud/sprites/countdown_overlay",
			"ui/combat_hud/sprites/countdown_overlay",
			"ui/combat_hud/sprites/countdown_overlay"
		], ["three", "two", "one", "fight"], [
			"ui/combat_hud/sounds/countdown_three",
			"ui/combat_hud/sounds/countdown_two",
			"ui/combat_hud/sounds/countdown_one",
			"ui/combat_hud/sounds/countdown_fight"
		]);
		countdownOverlay.screenCenter();
		add(countdownOverlay);

		// Add the death overlay
		deathOverlay = new NotificationOverlay(0.0, 0.0, "ui/combat_hud/sprites/death_overlay", "ui/combat_hud/sounds/death_overlay");
		deathOverlay.screenCenter();
		add(deathOverlay);
	}

	/** Plays an animation to show the player health bar. **/
	public function showPlayerHealth()
	{
		playerHealth.visible = true;
		FlxTween.cancelTweensOf(playerHealth);
		FlxTween.linearMotion(playerHealth, playerHealth.x, -20.0 - playerHealth.height, playerHealth.x, -20.0);
	}

	/** Plays an animation to hide the player health bar. **/
	public function hidePlayerHealth()
	{
		FlxTween.cancelTweensOf(playerHealth);
		FlxTween.linearMotion(playerHealth, playerHealth.x, -20.0, playerHealth.x, -20.0 - playerHealth.height, 1.0, true, {
			onComplete: function(tween:FlxTween)
			{
				playerHealth.visible = false;
			}
		});
	}

	/** Plays an animation to show the boss health bar. **/
	public function showBossHealth()
	{
		bossHealth.visible = true;
		FlxTween.cancelTweensOf(bossHealth);
		FlxTween.linearMotion(bossHealth, bossHealth.x, FlxG.height, bossHealth.x, FlxG.height - bossHealth.height);
	}

	/** Plays an animation to hide the boss health bar. **/
	public function hideBossHealth()
	{
		FlxTween.cancelTweensOf(bossHealth);
		FlxTween.linearMotion(bossHealth, bossHealth.x, FlxG.height - bossHealth.height, bossHealth.x, FlxG.height, 1.0, true, {
			onComplete: function(tween:FlxTween)
			{
				bossHealth.visible = false;
			}
		});
	}

	/** Plays an animation to flash the screen with a sprite. **/
	public function showFlashOverlay(color:FlxColor)
	{
		flashOverlay.color = color;
		flashOverlay.alpha = 1.0;
		flashOverlay.visible = true;
		FlxTween.cancelTweensOf(flashOverlay);
		FlxTween.tween(flashOverlay, {alpha: 0.0}, 0.3, {
			onComplete: function(tween:FlxTween)
			{
				flashOverlay.visible = false;
			}
		});
	}
}
