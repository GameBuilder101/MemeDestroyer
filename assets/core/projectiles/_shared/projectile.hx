// Requires variables fireSpeed:Float
var fireTeam:String;
var fireX:Float;
var fireY:Float;
var fireAngle:Float;
var fireVelocity:Float;

function onLoaded()
{
	this.tags.push("projectile");
	this.kill();
}

function onUpdate()
{
	this.x += FlxMath.fastCos(fireAngle * FlxAngle.TO_RAD) * fireSpeed * fireVelocity;
	this.y += FlxMath.fastSin(fireAngle * FlxAngle.TO_RAD) * fireSpeed * fireVelocity;

	// If the projectile leaves the bounds, kill it
	if ((this.x < FlxG.worldBounds.left - 32.0
		|| this.x > FlxG.worldBounds.right + 32.0 - this.mainSprite.width
		|| this.y < FlxG.worldBounds.top - 32.0
		|| this.y > FlxG.worldBounds.bottom + 32.0 - this.mainSprite.height)
		&& this.alive)
		this.kill();
}

function fire(team:String, x:Float, y:Float, angle:Float, velocity:Float = 1.0)
{
	fireTeam = team;
	fireX = x;
	fireY = y;
	fireAngle = angle;
	fireVelocity = velocity;

	setAll("team", fireTeam);

	this.revive();
	this.setPosition(fireX, fireY);
	this.mainSprite.angle = fireAngle;
	if (animation.exists("team_" + fireTeam))
		animation.play("team_" + fireTeam);
}
