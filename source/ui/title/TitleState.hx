package ui.title;

import flixel.FlxG;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.particles.FlxEmitter;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import gbc.graphics.AssetSprite;
import gbc.graphics.AssetSpriteRegistry;
import gbc.sound.AssetMusicRegistry;
import gbc.sound.MusicManager;

class TitleState extends FlxTransitionableState
{
	public var background(default, null):AssetSprite;

	public var embers(default, null):FlxEmitter;

	public var logo(default, null):AssetSprite;

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

		logo = new AssetSprite(0.0, 0.0, null, "ui/title/sprites/logo");
		logo.x = FlxG.width - logo.width;
		logo.scrollFactor.set(0.0, 0.0);
		add(logo);
		FlxTween.linearMotion(logo, logo.x, logo.y, logo.x, logo.y + 8.0, 2.0, true, {
			ease: FlxEase.quadInOut,
			type: PINGPONG
		});

		introCredit = new FlxText(0.0, FlxG.height / 2.0 - 32.0, FlxG.width);
		introCredit.setFormat("Edit Undo BRK", 24, FlxColor.WHITE, CENTER, SHADOW, FlxColor.BLACK);
		introCredit.scrollFactor.set(0.0, 0.0);
		introCredit.visible = false;
		add(introCredit);

		introTimer = new FlxTimer();
		introCreditTimer = new FlxTimer();

		startIntro();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		// Continuously emit the ember particles
		if (!embers.emitting)
			embers.start(false);
	}

	public function startIntro()
	{
		introTimer.start(INTRO_DURATION, function(timer:FlxTimer)
		{
			endIntro();
		});

		logo.visible = false;

		// Start the background zoomed-in at the bottom and scroll upwards
		FlxTween.cancelTweensOf(background);
		background.scale.set(3.0, 3.0);
		background.updateHitbox();
		background.x = (FlxG.width - background.width) / 2.0;
		FlxTween.linearMotion(background, background.x, FlxG.height - background.height, background.x, (FlxG.height - background.height) * 0.5,
			INTRO_DURATION);

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

	public function endIntro()
	{
		introTimer.cancel();

		FlxG.camera.flash(FlxColor.WHITE, 0.1);

		// Reset other elements
		logo.visible = true;

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

	/** Returns true if the intro animation is playing. **/
	public function getPlayingIntro():Bool
	{
		return !introTimer.finished;
	}
}
