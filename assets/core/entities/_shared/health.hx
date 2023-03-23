// Requires variables initialMaxHealth:Float, initialInvFrames:Float, roundHealth:Bool, healthColor:String, healthType:String, team:String, hurtSoundID:String, dieSoundID:String

var health:Float;
var maxHealth:Float;

// The invincibility frames
var invFrames:Float;
var maxInvFrames:Float;

// While invulnerable, this health cannot be damaged (separate from invincibility frames)
var invulnerable:Bool = false;
var healSound:AssetSound;
var hurtSound:AssetSound;
var dieSound:AssetSound;

function onLoaded()
{
	maxHealth = initialMaxHealth;
	health = maxHealth;

	maxInvFrames = initialInvFrames;
	invFrames = 0.0;

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

	healSound = AssetSoundRegistry.getAsset("entities/_shared/sounds/heal");
	hurtSound = AssetSoundRegistry.getAsset(hurtSoundID);
	dieSound = AssetSoundRegistry.getAsset(dieSoundID);
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
	var wasAlive:Bool = getIsAlive();

	if (roundHealth)
		health = Math.round(value);
	else
		health = value;
	if (health < 0.0)
		health = 0.0;
	else if (health > maxHealth)
		health = maxHealth;

	if (!getIsAlive() && wasAlive) // Death triggering
	{
		if (dieSound != null)
			dieSound.play();
		callAll("onDie", [value]);
	}
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
		setHealth(maxHealth);
}

function getIsAlive()
{
	return health > 0.0;
}

// Either subtracts OR adds to the health. Subtracting does nothing if invincibility frames are active
function damage(value:Float)
{
	if (value == 0.0 || (value < 0.0 && (invFrames > 0.0 || invulnerable)))
		return;
	FlxTween.cancelTweensOf(this.mainSprite);
	if (value < 0.0)
	{
		invFrames = maxInvFrames;
		FlxTween.color(this.mainSprite, 0.4, colorString("#ff0000"), colorString("#ffffff"));
		if (hurtSound != null)
			hurtSound.play();
		callAll("onHurt", [value]);
	}
	else
	{
		FlxTween.color(this.mainSprite, 0.4, colorString("#00ff00"), colorString("#ffffff"));
		if (healSound != null)
			healSound.play();
		callAll("onHealed", [value]);
	}
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

function setInvulnerable(value:Bool)
{
	invulnerable = value;
}

function onOverlap(tag:String, entity:Entity)
{
	if (tag != "damager")
		return;
	var damager:GameScript = entity.getComponent("damager");
	if (damager.get("team") != team)
		damage(damager.call("getContactDamage"));
}
