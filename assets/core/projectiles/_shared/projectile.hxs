// Requires variables fireSpeed:Float, damage:Float, riposteMultiplier:Float
var fireTeam:String;
var firePos:Point;
var fireAngle:Float;

function onLoaded()
{
	this.tags.push("projectile");
	this.kill();
}

function onUpdate()
{
	this.x += FlxMath.fastCos(FlxAngle.asRadians(fireAngle)) * fireSpeed;
	this.y += FlxMath.fastSin(FlxAngle.asRadians(fireAngle)) * fireSpeed;

	// If the projectile leaves the bounds, kill it
	if ((this.x < FlxG.worldBounds.left - 32.0
		|| this.x > FlxG.worldBounds.right + 32.0 - this.mainSprite.width
		|| this.y < FlxG.worldBounds.top - 32.0
		|| this.y > FlxG.worldBounds.bottom + 32.0 - this.mainSprite.height)
		&& this.alive)
		this.kill();
}

function fire(team:String, pos:Point, angle:Float, riposte:Bool = false)
{
	fireTeam = team;
	firePos = pos;
	fireAngle = angle;

	setAll("team", fireTeam);
	// Make the contact damage to the projectile damage
	if (riposte)
		setAll("contactDamage", damage * riposteMultiplier);
	else
		setAll("contactDamage", damage);

	this.revive();
	this.setPosition(firePos.getX(), firePos.getY());
	this.mainSprite.angle = fireAngle;
	// Play the appropriate animation
	if (riposte && animation.exists("team_" + fireTeam + "_riposte"))
		animation.play("team_" + fireTeam + "_riposte");
	else if (animation.exists("team_" + fireTeam))
		animation.play("team_" + fireTeam);

	// For adittional components to add functionality
	callAll("onFired", [team, pos, angle, riposte]);
}
