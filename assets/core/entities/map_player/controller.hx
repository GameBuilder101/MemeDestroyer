var moving:Bool;
var moveTarget:Point;

// Component caches
var movement:GameScript;

function onLoaded()
{
	movement = getComponent("movement");
}

function onUpdate(elapsed:Float)
{
	if (!moving)
		return;

	var angle:Float = FlxAngle.angleBetweenPoint(this, moveTarget.point, true);
	var direction:Point = new Point(FlxMath.fastCos(angle), FlxMath.fastSin(angle));
	movement.call("move", [direction, false, elapsed]);
	if (this.x > moveTarget.point.x - 8.0 && this.x < moveTarget.point.x + 8.0 && this.y > moveTarget.point.y - 8.0 && this.y < moveTarget.point.y + 8.0)
	{
		moving = false; // Stop moving when within decent range of the target
		movement.call("move", [new Point(0.0, 0.0), false, 0.0]);
	}
}

function moveTo(position:Point)
{
	moving = true;
	moveTarget = position;
}
