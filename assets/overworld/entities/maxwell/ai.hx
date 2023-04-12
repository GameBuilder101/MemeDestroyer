var warningGlint:AssetSprite;
var warningGlintSound:AssetSound;

// Attack variables
var attackCooldown:Float = 3.0;
var currentAttackIndex:Int = -1;
var currentAttackTime:Float = -1.0;

// Spin attack variables
var spinDir:Point;

// Shoot attack variables
var shootCount:Int;

// Component caches
var movement:GameScript;
var shooter:GameScript;
var baseAI:GameScript;

function onLoaded()
{
	movement = getComponent("movement");
	shooter = getComponent("shooter");
	baseAI = getComponent("base_ai");

	warningGlint = new AssetSprite(0.0, 0.0, null, "entities/_shared/sprites/warning_glint");
	warningGlint.visible = false;
	state.effects.add(warningGlint);

	warningGlintSound = AssetSoundRegistry.getAsset("entities/_shared/sounds/warning_glint");
}

function onUpdate(elapsed:Float)
{
	warningGlint.visible = !warningGlint.animation.finished;

	if (baseAI.call("getTarget") == null)
	{
		baseAI.call("setTarget", [state.player]);
		return;
	}

	// If performing the current attack
	if (currentAttackTime >= 0.0)
	{
		switch (currentAttackIndex)
		{
			default:
				updateSpinAttack(elapsed);
				return;
			case 1:
				updateShootAttack(elapsed);
				return;
		}
	}

	movement.call("move", [baseAI.call("getFacingVector"), false, elapsed]);

	// Attacking
	attackCooldown -= elapsed;
	if (attackCooldown <= 0.0)
	{
		// Reset the cooldown to a random amount
		attackCooldown = 3.0;

		if (currentAttackIndex >= 1)
			currentAttackIndex = 0;
		else
			currentAttackIndex++;
		switch (currentAttackIndex)
		{
			default:
				startSpinAttack();
			case 1:
				startShootAttack();
		}
	}
}

function startSpinAttack()
{
	currentAttackTime = 3.0;

	spinDir = baseAI.call("getFacingVector");
	// Stop moving
	movement.call("move", [new Point(0.0, 0.0), false, 0.0]);

	warningGlint.setPosition(this.x, this.y);
	warningGlint.animation.play("spawn", true);
	warningGlint.visible = true;

	warningGlintSound.play();
}

function updateSpinAttack(elapsed:Float)
{
	// Give time for the player to prepare before spinning
	if (currentAttackTime > 2.0)
	{
		currentAttackTime -= elapsed;
		return;
	}

	movement.call("move", [spinDir, true, elapsed]);
}

// The spin attack duration is based on how many times the AI bounces
function onTouchedEdge(touchedEdge:Int, elapsed:Float)
{
	if (currentAttackTime < 0.0 || currentAttackIndex != 0)
		return;
	currentAttackTime--;

	// Bounce the vector
	if (touchedEdge <= 1)
		spinDir.point.x *= -1.0;
	else
		spinDir.point.y *= -1.0;

	state.levelCamera.shake(0.005, 0.1);
}

function startShootAttack()
{
	currentAttackTime = 1.0;

	shootCount = 0;
	// Stop moving
	movement.call("move", [new Point(0.0, 0.0), false, 0.0]);
}

function updateShootAttack(elapsed:Float)
{
	currentAttackTime -= elapsed;

	if ((currentAttackTime <= 0.666 && shootCount <= 0)
		|| (currentAttackTime <= 0.333 && shootCount <= 1)
		|| (currentAttackTime <= 0.0 && shootCount <= 2))
	{
		shooter.call("fire", ["projectiles/generic_bullet", baseAI.call("getTargetFacing"), false]);
		shootCount++;
	}
}
