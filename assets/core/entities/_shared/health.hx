// Requires variables initialMaxHealth:Float, roundHealth:Bool, healthColor:String

var health:Float;
var maxHealth:Float;

function onLoaded()
{
	maxHealth = initialMaxHealth;
	health = maxHealth;
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

// Either subtracts OR adds to the health
function damage(value:Float)
{
	setHealth(health + value);
}

function getIsAlive()
{
	return health > 0.0;
}

// Used for visuals such as health bars
function getHealthColor():Int
{
	return colorString(healthColor);
}
