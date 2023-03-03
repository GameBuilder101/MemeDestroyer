// Requires variables dodgeSpeed:Float, dodgeDuration:Float, dodgeCool:Float

var currentDodgeDirection:Point;
var currentDodgeTime:Float = 0.0;
var currentDodgeCool:Float = 0.0;

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
	comp("movement").call("move", [direction, false, elapsed]);

	// Dodging input
	if (Controls.dodge.check())
		dodge(direction);
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

	if (animation.exists("dodge"))
		animation.play("dodge", true);
}

// Finishes a dodge
function finishDodge()
{
	currentDodgeTime = 0.0;
	currentDodgeCool = dodgeCool;
}

function isDodging():Bool
{
	return currentDodgeTime > 0.0;
}
