// Requires variables dodgeSpeed:Float, dodgeDuration:Float, dodgeCool:Float

var currentDodgeDirection:Point;
var currentDodgeTime:Float = 0.0;
var currentDodgeCool:Float = 0.0;
var dodgeParticle:AssetSprite;
var dodgeSound:AssetSound;

// The interactable the player is currently in-range of
var interactable:GameScript;
var oldInteractable:GameScript;

// Component caches
var movement:GameScript;
var health:GameScript;

function onLoaded()
{
	movement = getComponent("movement");
	health = getComponent("health");

	dodgeParticle = new AssetSprite(0.0, 0.0, null, "entities/player/sprites/dodge_particle");
	dodgeParticle.visible = false;
	state.effects.add(dodgeParticle);

	dodgeSound = AssetSoundRegistry.getAsset("entities/player/sounds/dodge");
}

function onUpdate(elapsed:Float)
{
	// Dodging animation
	if (isDodging())
	{
		var scale:Float = dodgeSpeed * elapsed * (currentDodgeTime / dodgeDuration);
		this.x += currentDodgeDirection.point.x * scale;
		this.y += currentDodgeDirection.point.y * scale;

		currentDodgeTime -= elapsed;
		if (currentDodgeTime <= 0.0)
			finishDodge();
		return; // Prevent movement while dodging
	}
	else if (currentDodgeCool > 0.0)
	{
		currentDodgeCool -= elapsed;
		if (currentDodgeCool < 0.0)
			currentDodgeCool = 0.0;
	}

	dodgeParticle.visible = !dodgeParticle.animation.finished;

	// Directional movement
	var direction:Point = new Point(0.0, 0.0);
	direction.point.x = 0.0;
	direction.point.y = 0.0;
	if (Controls.moveUp.check())
		direction.point.y--;
	if (Controls.moveDown.check())
		direction.point.y++;
	if (Controls.moveLeft.check())
		direction.point.x--;
	if (Controls.moveRight.check())
		direction.point.x++;
	movement.call("move", [direction, false, elapsed]);

	// Dodging input
	if (Controls.dodge.check() && currentDodgeCool <= 0.0)
		dodge(direction);
	else if (!isDodging())
		this.flipX = this.x > FlxG.mouse.x; // Face the cursor when not dodging

	// Interactable range detection
	oldInteractable = interactable;
	interactable = null;
	overlap("interactable");
	if (oldInteractable != interactable && oldInteractable != null)
		oldInteractable.call("exitInteractRange", [this]);

	// Interaction
	if (interactable != null && Controls.interact.check())
		interactable.call("interact", [this]);
}

function getLookAngle():Float
{
	return FlxAngle.angleBetweenPoint(this, FlxG.mouse.getPosition(), true);
}

// Dodges towards the given direction
function dodge(direction:Point)
{
	if (direction.point.x == 0.0 && direction.point.y == 0.0)
		return;
	direction.normalize(); // Prevent diagonal movement from being faster
	currentDodgeDirection = direction;
	currentDodgeTime = dodgeDuration;
	currentDodgeCool = 0.0;

	health.call("setInvulnerable", [true]);

	if (animation.exists("dodge"))
		animation.play("dodge", true);
	dodgeParticle.setPosition(this.x, this.y);
	dodgeParticle.animation.play("spawn", true);
	dodgeParticle.visible = true;

	dodgeSound.play();
}

// Finishes a dodge
function finishDodge()
{
	currentDodgeTime = 0.0;
	currentDodgeCool = dodgeCool;

	health.call("setInvulnerable", [false]);
}

function isDodging():Bool
{
	return currentDodgeTime > 0.0;
}

function onOverlap(tag:String, entity:Entity)
{
	if (tag != "interactable" || entity.getComponent("interactable") == interactable)
		return;
	interactable = entity.getComponent("interactable");
	interactable.call("enterInteractRange", [this]);
}
