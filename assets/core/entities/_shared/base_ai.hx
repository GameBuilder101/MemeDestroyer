// Requires variables turnSpeed:Float
// The entity this AI is targeting
var target:Entity;

// The angle the AI is facing/moving towards
var facing:Float = 0.0;

function onUpdate(elapsed:Float)
{
	if (target != null && !target.alive)
		setTarget(null);
	if (target == null)
		return;

	// Get the angle the entity should be heading
	var targetFacing:Float = FlxAngle.angleBetween(this, target, true);

	/* Because angles are dumb, you can't just add/subtract the angle to reach the
		target angle. If the angles are split over the threshold between -180 and 180, this might
		cause the entity to do a full 360 degree rotation for something that should be a really small
		rotation */
	var flip:Bool = checkIfCrossThreshold(facing, targetFacing) || checkIfCrossThreshold(targetFacing, facing);
	if ((!flip && facing < targetFacing) || (flip && facing > targetFacing))
	{
		facing += turnSpeed * elapsed;
		if (facing > targetFacing)
			facing = targetFacing;
	}
	else if ((!flip && facing > targetFacing) || (flip && facing < targetFacing))
	{
		facing -= turnSpeed * elapsed;
		if (facing < targetFacing)
			facing = targetFacing;
	}
}

function checkIfCrossThreshold(angle1:Float, angle2:Float):Boolds
{
	return angle1 < 0.0 && angle2 > 0.0 && (180.0 + angle1) + (180.0 - angle2) < angle2 - angle1;
}

// Returns the facing angle of this AI
function getFacing():Float
{
	return facing;
}

// Returns the facing vector of this AI (based on the facing angle)
function getFacingVector():Point
{
	var rad:Float = FlxAngle.asRadians(facing);
	return new Point(FlxMath.fastCos(rad), FlxMath.fastSin(rad));
}

function setTarget(entity:Entity)
{
	target = entity;
}

function getTarget():Entity
{
	return target;
}

function onDie(value:Float)
{
	state.levelCamera.shake(0.005, 1.0);
	state.levelCamera.flash();
	state.removeEntity(this);

	// Create an explosion effect
	var explosion:Entity = state.spawn("entities/death_explosion", this.x + this.width / 2.0, this.y + this.height / 2.0);

	// Scale the explosion to match the size of this AI
	var biggerScale:Float = this.scale.x;
	if (this.scale.y > biggerScale)
		biggerScale = this.scale.y;
	if (explosion.scale.x < biggerScale)
		explosion.scale.set(biggerScale, biggerScale);
}
