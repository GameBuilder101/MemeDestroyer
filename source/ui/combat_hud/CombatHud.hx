package ui.combat_hud;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.tweens.FlxTween;

class CombatHud extends FlxTypedGroup<FlxSprite>
{
	/** Health indicator for player. **/
	public var playerHealth(default, null):HealthNotches;

	/** Health indicator for bosses. **/
	public var bossHealth(default, null):HealthBar;

	public var inventory(default, null):Inventory;

	public var ammoIndicator(default, null):AmmoIndicator;

	public var titleOverlay(default, null):TitleOverlay;

	public var countdownOverlay(default, null):CountdownOverlay;

	public var deathOverlay(default, null):NotificationOverlay;

	public function new()
	{
		super();

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
		ammoIndicator = new AmmoIndicator(0.0, 0.0);
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
}
