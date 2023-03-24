// Requires variables fireSpeed:Float, damage:Float, riposteMultiplier:Float
var fireTeam:String;
var fireX:Float;
var fireY:Float;
var fireAngle:Float;

function onLoaded()
{
	this.tags.push("projectile");
	this.kill();
}

function onUpdate()
{
	this.x += FlxMath.fastCos(fireAngle * FlxAngle.TO_RAD) * fireSpeed;
	this.y += FlxMath.fastSin(fireAngle * FlxAngle.TO_RAD) * fireSpeed;

	// If the projectile leaves the bounds, kill it
	if ((this.x < FlxG.worldBounds.left - 32.0
		|| this.x > FlxG.worldBounds.right + 32.0 - this.mainSprite.width
		|| this.y < FlxG.worldBounds.top - 32.0
		|| this.y > FlxG.worldBounds.bottom + 32.0 - this.mainSprite.height)
		&& this.alive)
		this.kill();
}

function fire(team:String, x:Float, y:Float, angle:Float, riposte:Bool = false)
{
	fireTeam = team;
	fireX = x;
	fireY = y;
	fireAngle = angle;

	setAll("team", fireTeam);
	// Make the contact damage to the projectile damage
	if (riposte)
		setAll("contactDamage", damage * riposteMultiplier);
	else
		setAll("contactDamage", damage);

	this.revive();
	this.setPosition(fireX, fireY);
	this.mainSprite.angle = fireAngle;
	// Play the appropriate animation
	if (riposte && animation.exists("team_" + fireTeam + "_riposte"))
		animation.play("team_" + fireTeam + "_riposte");
	else if (animation.exists("team_" + fireTeam))
		animation.play("team_" + fireTeam);

	// For adittional components to add functionality
	callAll("onFired", [team, x, y, angle, riposte]);
}
