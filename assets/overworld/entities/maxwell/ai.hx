// Attack variables
var attackCooldown:Float = 12.0;
var attackIndex:Int = 0;
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
}

function onUpdate(elapsed:Float)
{
	if (baseAI.call("getTarget") == null)
	{
		baseAI.call("setTarget", [state.player]);
		return;
	}

	// If performing the current attack
	if (currentAttackTime >= 0.0)
	{
		switch (attackIndex)
		{
			default:
				updateSpinAttack(elapsed);
				return;
			case 1:
				updateShootAttack(elapsed);
				return;
		}
	}

	// Attacking
	attackCooldown -= elapsed;
	if (attackCooldown <= 0.0)
	{
		// Reset the cooldown to a random amount
		attackCooldown = 4.0 + Math.random() * 3.0;

		switch (attackIndex)
		{
			default:
				startSpinAttack();
			case 1:
				startShootAttack();
				attackIndex = -1; // Will get increased to 0 immediately after
		}
		attackIndex++;
	}

	movement.call("move", [baseAI.call("getFacingVector"), false, elapsed]);
}

function startSpinAttack()
{
	currentAttackTime = 1.0;
	spinDir = baseAI.call("getFacingVector");
	animation.play("spin");
}

function updateSpinAttack(elapsed:Float)
{
	movement.call("move", [spinDir, true, elapsed]);
}

function onTouchedEdge(touchedEdge:Int, elapsed:Float)
{
	if (attackIndex != 0)
		return;
	currentAttackTime -= 1.0;
	// Bounce the vector
	if (touchedEdge <= 1)
		spinDir.point.y *= -1.0;
	else
		spinDir.point.x *= -1.0;
}

function startShootAttack()
{
	currentAttackTime = 3.0;
	shootCount = 0;
	// Stop moving
	movement.call("move", [new Point(0.0, 0.0, false, 0.0)]);
}

function updateShootAttack(elapsed:Float)
{
	currentAttackTime -= elapsed;
	if ((currentAttackTime <= 2.0 && shootCount <= 0)
		|| (currentAttackTime <= 1.0 && shootCount <= 1)
		|| (currentAttackTime <= 0.0 && shootCount <= 2))
	{
		shooter.call("fire", ["projectiles/generic_bullet", baseAI.call("getTargetFacingVector")]);
		shootCount++;
	}
}
