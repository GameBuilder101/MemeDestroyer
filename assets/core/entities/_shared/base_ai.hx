// Requires variables turnSpeed:Float, targetPlayerOnLoaded:Bool
// The entity this AI is targeting
var target:Entity;

// The angle the AI is facing/moving towards
var facing:Float = 0.0;

function onLoaded()
{
	if (targetPlayerOnLoaded)
		setTarget(state.player);
}

function onUpdate(elapsed:Float)
{
	if (target == null)
		return;

	// Get the angle the entity should be heading
	var targetFacing:Float = FlxAngle.angleBetween(this, target, true);

	/* Because angles are dumb, you can't just add/subtract the angle to reach the
		target angle. If the angles are split over the threshold between -180 and 180, this might
		cause the entity to do a full 360 degree rotation for something that should be a really small
		rotation */
	var flip:Bool = checkIfCrossThreshold(facing, targetFacing) || checkIfCrossThreshold(targetFacing, facing);

	if (targetFacing < 0.0 && facing > 0.0 && 180.0 + targetFacing + 180.0 - facing > facing + targetFacing)
		flip = true;
	else if (targetFacing > 0.0 && facing)
		if (facing < targetFacing)
		{
			if (flip)
				facing -= turnSpeed * elapsed;
			else
				facing += turnSpeed * elapsed;
		}
		else if (targetFacing > facing)
		{
			if (flip)
				facing += turnSpeed * elapsed;
			else
				facing -= turnSpeed * elapsed;
		}
}

function checkIfCrossThreshold(angle1:Float, angle2:Float):Bool
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
	var vector:Point = new Point();
	vector.point.x = FlxMath.fastCos(rad);
	vector.point.y = FlxMath.fastSin(rad);
	return vector;
}

function setTarget(entity:Entity)
{
	target = entity;
}

function getTarget():Entity
{
	return target;
}
