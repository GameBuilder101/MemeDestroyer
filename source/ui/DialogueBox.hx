package ui;

import flixel.group.FlxSpriteGroup;
import flixel.sound.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import gbc.graphics.AssetSprite;
import gbc.sound.AssetSound;
import gbc.sound.AssetSoundRegistry;

class DialogueBox extends FlxSpriteGroup implements IOverlay
{
	/** How long it takes to type a single character. **/
	static inline final TYPE_DELAY:Float = 0.03;

	/** How long to wait after typing all characters. **/
	static inline final CLOSE_DELAY:Float = 4.0;

	var background:AssetSprite;
	var portrait:AssetSprite;
	var name:FlxText;
	var dialogue:FlxText;

	/** The text to be typed. **/
	var speakingText:String;

	/** The speaking/idle animation pair to play. **/
	var animVariant:String;

	var speakingSound:AssetSound;

	var speakingSoundSource:FlxSound;

	var delayTimer:FlxTimer;

	/** True when still displaying. **/
	public var displaying(default, null):Bool;

	var onComplete:Void->Void;

	public function new(x:Float = 0.0, y:Float = 0.0)
	{
		super(x, y);
		scrollFactor.set(0.0, 0.0);

		background = new AssetSprite(0.0, 0.0, null, "ui/_shared/sprites/dialogue_background");
		background.visible = false;
		add(background);

		portrait = new AssetSprite(background.width / 2.0 - 256.0, background.height / 2.0 - 32.0);
		portrait.visible = false;
		add(portrait);

		name = new FlxText(portrait.x + 80.0, portrait.y, 432.0);
		name.setFormat("Edit Undo BRK", 24, FlxColor.WHITE, LEFT, SHADOW, FlxColor.BLACK);
		name.visible = false;
		add(name);

		dialogue = new FlxText(portrait.x + 80.0, portrait.y + 24.0, 432.0);
		dialogue.setFormat("Edit Undo BRK", 18, FlxColor.WHITE, LEFT, SHADOW, FlxColor.BLACK);
		dialogue.visible = false;
		add(dialogue);

		speakingSoundSource = new FlxSound();

		delayTimer = new FlxTimer();
	}

	public function display(args:Dynamic, onComplete:Void->Void)
	{
		this.onComplete = onComplete;
		displaying = true;

		delayTimer.cancel();

		animVariant = args.animVariant;
		portrait.loadFromID(args.portraitSpriteID);
		portrait.animation.play("idle_" + animVariant);

		speakingText = args.text;
		speakingSound = AssetSoundRegistry.getAsset(args.speakingSoundID);

		name.text = args.name;
		dialogue.text = ""; // Start the dialogue empty

		FlxTween.cancelTweensOf(background);
		background.alpha = 0.0;
		background.visible = true;
		FlxTween.tween(background, {alpha: 1.0}, 0.1, {onComplete: onCompleteFadeIn});

		FlxTween.cancelTweensOf(portrait);
		portrait.scale.x = 0.0;
		portrait.visible = true;
		FlxTween.tween(portrait, {"scale.x": 1.0}, 0.1);
	}

	/** Called when the fade-in is finished. **/
	function onCompleteFadeIn(tween:FlxTween)
	{
		name.visible = true;
		dialogue.visible = true;

		portrait.animation.play("speaking_" + animVariant);

		// Type out the text character-by-character, playing a sound each time
		delayTimer.start(TYPE_DELAY, function(timer:FlxTimer)
		{
			dialogue.text += speakingText.charAt(timer.elapsedLoops - 1);
			if (speakingSound != null)
				speakingSound.playOn(speakingSoundSource);

			if (timer.elapsedLoops >= speakingText.length)
			{
				portrait.animation.play("idle_" + animVariant);
				delayTimer.start(CLOSE_DELAY, function(timer:FlxTimer)
				{
					onCompleteSpeaking();
				});
			}
		}, speakingText.length);
	}

	function onCompleteSpeaking()
	{
		name.visible = false;
		dialogue.visible = false;
		FlxTween.tween(background, {alpha: 0.0}, 0.1, {onComplete: onCompleteFadeOut});
		FlxTween.tween(portrait, {"scale.x": 0.0}, 0.1);
	}

	/** Called when the fade-out is finished. **/
	function onCompleteFadeOut(tween:FlxTween)
	{
		background.visible = false;
		portrait.visible = false;

		displaying = false;
		if (onComplete != null)
			onComplete();
	}
}
