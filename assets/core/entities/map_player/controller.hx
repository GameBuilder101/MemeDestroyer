var moving:Bool;
var movePosition:Point;
var initialPosition:Point;

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

	var position = new Point(this.x, this.y);
	var angle:Float = position.radiansTo(movePosition);
	var direction:Point = new Point(FlxMath.fastCos(angle), FlxMath.fastSin(angle));
	movement.call("move", [direction, false, elapsed]);
	// If the entity has moved beyond the target position
	if (position.dist(initialPosition) > movePosition.dist(initialPosition))
	{
		moving = false;
		this.x = movePosition.getX();
		this.y = movePosition.getY();
		movement.call("move", [new Point(0.0, 0.0), false, 0.0]); // Stop moving
	}
}

function moveTo(position:Point)
{
	moving = true;
	movePosition = position;
	initialPosition = new Point(this.x, this.y);
}
