// Requires variables initialMaxHealth:Float, initialInvFrames:Float, roundHealth:Bool, healthColor:String, healthType:String

var health:Float;
var maxHealth:Float;

// The invincibility frames
var invFrames:Float;
var maxInvFrames:Float;

function onLoaded()
{
	maxHealth = initialMaxHealth;
	health = maxHealth;

	maxInvFrames = initialInvFrames;
	invFrames = 0.0;

	if (healthType != null)
	{
		switch (healthType)
		{
			case "player":
				state.playerHealth.setLabel(this.name);
				state.playerHealth.setIndicatorColor(colorString(healthColor));
			case "boss":
				state.bossHealth.setLabel(this.name);
				state.bossHealth.setIndicatorColor(colorString(healthColor));
			default:
		}
	}
}

function onUpdate(elapsed:Float)
{
	// Update the health bar (if there is one for this entity)
	if (healthType != null)
	{
		switch (healthType)
		{
			case "player":
				state.playerHealth.setValues(health, maxHealth);
			case "boss":
				state.bossHealth.setValues(health, maxHealth);
			default:
		}
	}

	// Tick down invincibility frames
	if (invFrames > 0.0)
		invFrames -= elapsed;
	else if (invFrames < 0.0)
		invFrames = 0.0;

	// Look for damage sources
	overlap("damager");
}

function getHealth():Float
{
	return health;
}

function setHealth(value:Float)
{
	if (roundHealth)
		health = Math.round(value);
	else
		health = value;
	if (health < 0.0)
		health = 0.0;
	else if (health > maxHealth)
		health = maxHealth;
}

function getMaxHealth():Float
{
	return maxHealth;
}

function setMaxHealth(value:Float)
{
	if (roundHealth)
		maxHealth = Math.round(value);
	else
		maxHealth = value;
	if (health > maxHealth)
		health = maxHealth;
}

function getIsAlive()
{
	return health > 0.0;
}

// Either subtracts OR adds to the health. Subtracting does nothing if invincibility frames are active
function damage(value:Float)
{
	if (value == 0.0 || (value < 0.0 && invFrames > 0.0))
		return;
	if (value < 0.0)
	{
		invFrames = maxInvFrames;
		callAll("onHurt", [value]);
	}
	else
		callAll("onHealed", [value]);
	setHealth(health + value);
}

function getMaxInvFrames():Float
{
	return maxInvFrames;
}

function setMaxInvFrames(value:Float)
{
	maxInvFrames = value;
}

function onOverlap(tag:String, entity:Entity)
{
	if (tag != "damager")
		return;
	damage(entity.getComponent("damager").call("getContactDamage"));
}
