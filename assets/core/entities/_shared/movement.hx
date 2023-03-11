// Requires variables walkSpeed:Float, runSpeed:Float, footstepSoundID:String, footstepDelay:Float

var isWalking:Bool = false;
var isRunning:Bool = false;
var footstepSound:AssetSound;
var currentFootstepDelay:Float;

function onLoaded()
{
	if (footstepSoundID != null)
		footstepSound = AssetSoundRegistry.getAsset(footstepSoundID);
}

function onUpdate(elapsed:Float)
{
	// Keep the entity in screen bounds
	if (this.x < 0.0)
		this.x = 0.0;
	if (this.x > FlxG.width - this.mainSprite.width)
		this.x = FlxG.width - this.mainSprite.width;
	if (this.y < 0.0)
		this.y = 0.0;
	if (this.y > FlxG.height - this.mainSprite.height)
		this.y = FlxG.height - this.mainSprite.height;

	// Animation logic
	if ((animation.name == "run" || animation.name == "walk" || animation.name == "idle") || animation.finished)
	{
		if (isRunning)
		{
			if (animation.name != "run" && animation.exists("run"))
				animation.play("run");
		}
		else if (isWalking)
		{
			if (animation.name != "walk" && animation.exists("walk"))
				animation.play("walk");
		}
		else if (animation.name != "idle" && animation.exists("idle"))
			animation.play("idle");
	}

	// Footstep sound
	if (isWalking || isRunning)
		currentFootstepDelay += elapsed;
	else
		currentFootstepDelay = 0.0;

	if ((isWalking && currentFootstepDelay >= footstepDelay)
		|| (isRunning && currentFootstepDelay >= footstepDelay * (runSpeed / walkSpeed)))
	{
		if (footstepSound != null)
			footstepSound.play();
		currentFootstepDelay = 0.0;
	}
}

function move(direction:Point, running:Bool, elapsed:Float)
{
	isWalking = false;
	isRunning = false;
	if (direction.point.x == 0.0 && direction.point.y == 0.0)
		return;
	isWalking = !running;
	isRunning = running;

	direction.normalize(); // Prevent diagonal movement from being faster
	if (running)
	{
		this.x += direction.point.x * runSpeed * elapsed;
		this.y += direction.point.y * runSpeed * elapsed;
	}
	else
	{
		this.x += direction.point.x * walkSpeed * elapsed;
		this.y += direction.point.y * walkSpeed * elapsed;
	}

	if (direction.point.x != 0.0)
		this.flipX = direction.point.x < 0.0;

	onUpdate(elapsed);
}
