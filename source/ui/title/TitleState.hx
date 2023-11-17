package ui.title;

import flixel.FlxG;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.particles.FlxEmitter;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import gbc.assets.LibraryManager;
import gbc.graphics.AssetSprite;
import gbc.graphics.AssetSpriteRegistry;
import gbc.graphics.TransitionDataRegistry;
import gbc.sound.AssetMusicRegistry;
import gbc.sound.AssetSoundRegistry;
import gbc.sound.MusicManager;
import lime.system.System;

class TitleState extends FlxTransitionableState
{
	public var background(default, null):AssetSprite;

	public var embers(default, null):FlxEmitter;

	var glow:AssetSprite;

	public var logo(default, null):AssetSprite;

	/** Used to indicate the version of the game. **/
	public var versionText:FlxText;

	public var newButton(default, null):StandardButton;
	public var loadButton(default, null):StandardButton;
	public var quitButton(default, null):StandardButton;
	public var globalVolumeSlider(default, null):GlobalVolumeSlider;

	public var saveScreen(default, null):SaveScreen;
	public var cancelSaveButton(default, null):StandardButton;

	static inline final INTRO_DURATION:Float = 9.7;
	static inline final INTRO_CREDIT_APPEAR_TIME:Float = 2.45;
	static inline final INTRO_CREDIT_MODIFY_TIME:Float = 2.65;
	static inline final INTRO_CREDIT_HIDE_TIME:Float = 2.0;

	var introCredit:FlxText;

	/** The main intro timer that counts down to the end. **/
	var introTimer:FlxTimer;

	var introCreditTimer:FlxTimer;

	override function create()
	{
		super.create();

		// Play the main title theme
		MusicManager.transition(AssetMusicRegistry.getAsset("ui/title/music/main_theme"), 0.0);

		background = new AssetSprite(0.0, 0.0, null, "ui/title/sprites/background");
		add(background);

		embers = new FlxEmitter(-FlxG.width * 0.25, FlxG.height + 16.0);
		embers.setSize(FlxG.width, 0.0);
		embers.loadParticles(AssetSpriteRegistry.getAsset("ui/title/sprites/ember_particle").graphic);
		embers.frequency = 0.01;
		embers.launchAngle.set(300.0, 310.0);
		embers.angle.set(300.0, 310.0);
		embers.speed.set(400.0);
		embers.velocity.set(-400.0);
		embers.lifespan.set(1.5);
		add(embers);

		glow = new AssetSprite(0.0, 0.0, null, "ui/title/sprites/glow");
		glow.y = FlxG.height - glow.height;
		add(glow);
		FlxTween.tween(glow, {alpha: 0.1}, 1.0, {ease: FlxEase.quadInOut, type: PINGPONG});

		logo = new AssetSprite(0.0, 0.0, null, "ui/title/sprites/logo");
		logo.x = FlxG.width - logo.width;
		logo.scrollFactor.set(0.0, 0.0);
		add(logo);
		FlxTween.linearMotion(logo, logo.x, logo.y, logo.x, logo.y + 8.0, 2.0, true, {
			ease: FlxEase.quadInOut,
			type: PINGPONG
		});

		versionText = new FlxText(8.0, FlxG.height - 16.0, FlxG.width - 16.0, "Version " + LibraryManager.registry.get("assets").version);
		versionText.setFormat("Edit Undo BRK", 10, FlxColor.WHITE, LEFT);
		versionText.alpha = 0.5;
		versionText.scrollFactor.set(0.0, 0.0);
		add(versionText);

		newButton = new StandardButton(0.0, 44.0, "ui/title/sprites/button", "New Game", LEFT, newGame);
		add(newButton);
		loadButton = new StandardButton(newButton.x, newButton.y + newButton.height + 8.0, "ui/title/sprites/button", "Load Game", LEFT, openLoadMenu);
		add(loadButton);
		quitButton = new StandardButton(loadButton.x, loadButton.y + loadButton.height + 8.0, "ui/title/sprites/button", "Quit", LEFT, quitGame);
		add(quitButton);
		globalVolumeSlider = new GlobalVolumeSlider(quitButton.x, quitButton.y + quitButton.height + 8.0);
		add(globalVolumeSlider);

		cancelSaveButton = new StandardButton(0.0, 0.0, "ui/_shared/sprites/button", "Back", CENTER, openStandardMenu);
		cancelSaveButton.screenCenter();
		cancelSaveButton.y = FlxG.height - 48.0;
		add(cancelSaveButton);

		introCredit = new FlxText(0.0, FlxG.height / 2.0 - 32.0, FlxG.width);
		introCredit.setFormat("Edit Undo BRK", 24, FlxColor.WHITE, CENTER, SHADOW, FlxColor.BLACK);
		introCredit.scrollFactor.set(0.0, 0.0);
		introCredit.visible = false;
		add(introCredit);

		introTimer = new FlxTimer();
		introCreditTimer = new FlxTimer();

		openStandardMenu();
		startIntro();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		// Continuously emit the ember particles
		if (!embers.emitting)
			embers.start(false);

		if (Controls.pause.check())
			skipIntro();
	}

	/** Starts the new game transition. **/
	public function newGame()
	{
		transOut = TransitionDataRegistry.getAsset("transitions/start_game");

		// Zoom in the camera while transitioning
		FlxTween.tween(FlxG.camera, {zoom: 1.5}, 2.0);

		MusicManager.fadeOut(0.0);
		AssetSoundRegistry.getAsset("ui/_shared/sounds/start_game").play();

		// Loads in data for a new game
		GameSaver.instance.loadNewGame();
		FlxG.switchState(new PlayState("levels/init"));
	}

	/** Starts the quit game transition. **/
	public function quitGame()
	{
		transOut = TransitionDataRegistry.getAsset("transitions/quit_game");

		MusicManager.fadeOut(transOut.duration);
		AssetSoundRegistry.getAsset("ui/title/sounds/quit_game").play();

		transitionOut(function()
		{
			System.exit(0);
		});
	}

	function openStandardMenu()
	{
		logo.visible = true;
		newButton.visible = true;
		loadButton.visible = true;
		quitButton.visible = true;
		globalVolumeSlider.visible = true;

		if (saveScreen != null)
		{
			remove(saveScreen, true);
			saveScreen.destroy();
			saveScreen = null;
		}
		cancelSaveButton.visible = false;
	}

	function openLoadMenu()
	{
		logo.visible = false;
		newButton.visible = false;
		loadButton.visible = false;
		quitButton.visible = false;
		globalVolumeSlider.visible = false;

		saveScreen = new SaveScreen(0.0, 0.0, LOAD);
		add(saveScreen);
		cancelSaveButton.visible = true;
	}

	public function startIntro()
	{
		introTimer.start(INTRO_DURATION, function(timer:FlxTimer)
		{
			endIntro();
		});

		logo.visible = false;
		versionText.visible = false;
		newButton.visible = false;
		loadButton.visible = false;
		quitButton.visible = false;
		globalVolumeSlider.visible = false;

		// Start the background zoomed-in at the bottom and scroll upwards
		FlxTween.cancelTweensOf(background);
		background.scale.set(3.0, 3.0);
		background.updateHitbox();
		background.x = (FlxG.width - background.width) / 2.0;
		FlxTween.linearMotion(background, background.x, FlxG.height - background.height, background.x, (FlxG.height - background.height) * 0.5, INTRO_DURATION);

		// Start the intro credit text hidden, and change at specific points
		introCredit.visible = false;
		introCredit.text = "GameBuilder101";
		introCreditTimer.start(INTRO_CREDIT_APPEAR_TIME, function(timer:FlxTimer)
		{
			introCredit.visible = true;
			introCreditTimer.start(INTRO_CREDIT_MODIFY_TIME, function(timer:FlxTimer)
			{
				introCredit.text += "\nPresents";
				introCreditTimer.start(INTRO_CREDIT_HIDE_TIME, function(timer:FlxTimer)
				{
					introCredit.visible = false;
				});
			});
		});
	}

	function endIntro()
	{
		introTimer.cancel();

		FlxG.camera.flash(FlxColor.WHITE, 0.1);

		// Reset other elements
		openStandardMenu();

		// Reset the background
		background.scale.set(1.03, 1.03);
		background.updateHitbox();
		FlxTween.circularMotion(background, (FlxG.width - background.width) / 2.0, (FlxG.height - background.height) / 2.0,
			(background.height - FlxG.height) / 2.0, 0.0, true, 10.0, true, {
				type: LOOPING
			});

		// Reset the intro credit
		introCreditTimer.cancel();
		introCredit.visible = false;
	}

	public function skipIntro()
	{
		if (!introTimer.active)
			return;
		FlxG.sound.music.time = INTRO_DURATION * 1000.0; // Multiply by 1000 since the time is in milliseconds
		endIntro();
	}

	/** Returns true if the intro animation is playing. **/
	public function getPlayingIntro():Bool
	{
		return !introTimer.finished;
	}
}
