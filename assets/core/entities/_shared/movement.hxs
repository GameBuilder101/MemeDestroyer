// Requires variables walkSpeed:Float, runSpeed:Float, footstepSoundID:String, footstepDelay:Float

var isWalking:Bool = false;
var isRunning:Bool = false;
var footstepSound:AssetSound;
var currentFootstepDelay:Float = 0.0;

function onLoaded()
{
	footstepSound = AssetSoundRegistry.getAsset(footstepSoundID);
}

function onUpdate(elapsed:Float)
{
	var touchedEdge:Int = -1;
	// Keep the entity in world bounds
	if (this.x < FlxG.worldBounds.left)
	{
		this.x = FlxG.worldBounds.left;
		touchedEdge = 0;
	}
	else if (this.x > FlxG.worldBounds.right - this.mainSprite.width)
	{
		this.x = FlxG.worldBounds.right - this.mainSprite.width;
		touchedEdge = 1;
	}
	if (this.y < FlxG.worldBounds.top)
	{
		this.y = FlxG.worldBounds.top;
		touchedEdge = 2;
	}
	else if (this.y > FlxG.worldBounds.bottom - this.mainSprite.height)
	{
		this.y = FlxG.worldBounds.bottom - this.mainSprite.height;
		touchedEdge = 3;
	}
	if (touchedEdge >= 0)
		callAll("onTouchedEdge", [touchedEdge, elapsed]);

	// Animation logic
	if ((animation.name == "run" || animation.name == "walk" || animation.name == "idle") || animation.finished)
	{
		if (isRunning)
		{
			if (animation.exists("run"))
				animation.play("run");
		}
		else if (isWalking)
		{
			if (animation.exists("walk"))
				animation.play("walk");
		}
		else if (animation.exists("idle"))
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
	if (direction.getX() == 0.0 && direction.getY() == 0.0)
		return;
	isWalking = !running;
	isRunning = running;

	direction.normalize(); // Prevent diagonal movement from being faster
	if (running)
	{
		this.x += direction.getX() * runSpeed * elapsed;
		this.y += direction.getY() * runSpeed * elapsed;
	}
	else
	{
		this.x += direction.getX() * walkSpeed * elapsed;
		this.y += direction.getY() * walkSpeed * elapsed;
	}

	if (direction.getX() != 0.0)
		this.flipX = direction.getX() < 0.0;

	onUpdate(elapsed);
}
