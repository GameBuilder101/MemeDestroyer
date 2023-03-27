// Requires variables riposteDuration:Float

var equipped:Entity;

// The currently-equipped item component
var equippedItem:GameScript;

// The default hands sprite
var hands:AssetSprite;

// Used for riposte frames
var currentRiposteTime:Float = 0.0;
var riposteParticle:AssetSprite;
var riposteTriggerSound:AssetSound;
var riposteUseSound:AssetSound;

// Component caches
var health:GameScript;

function onLoaded()
{
	health = getComponent("health");

	hands = new AssetSprite(this.x, this.y, null, "entities/player/sprites/hands");
	this.add(hands);

	riposteParticle = new AssetSprite(0.0, 0.0, null, "entities/player/sprites/riposte_particle");
	riposteParticle.visible = false;
	this.add(riposteParticle);

	riposteTriggerSound = AssetSoundRegistry.getAsset("entities/player/sounds/riposte_trigger");
	riposteUseSound = AssetSoundRegistry.getAsset("entities/player/sounds/riposte_use");
}

function onUpdate(elapsed:Float)
{
	if (hands.animation.finished && hands.animation.exists("idle"))
		hands.animation.play("idle");

	// Riposte functionality
	if (currentRiposteTime > 0.0)
	{
		currentRiposteTime -= elapsed;
		if (currentRiposteTime < 0.0)
			currentRiposteTime = 0.0;
	}

	riposteParticle.visible = !riposteParticle.animation.finished;

	// Don't allow item usage when dead
	if (health != null && !health.call("getIsAlive"))
		return;

	if (equippedItem != null)
	{
		/* Hands sprite animation modes/angles must be done here so that flipping is
			detected properly */
		switch (equippedItem.call("getHeldSpriteMode"))
		{
			default:
				hands.angle = 0.0;
			case "rotating":
				hands.angle = FlxAngle.angleBetweenPoint(this, FlxG.mouse.getPosition(), true);
				if (this.flipX)
					hands.angle -= 180.0;
		}

		// Use input
		if (Controls.checkFire())
			attemptUse(elapsed);
	}
}

function equip(entity:Entity)
{
	if (entity == equipped)
		return;
	equipped = entity;
	equipped.visible = false;
	state.removeEntity(equipped);
	equipped.setPosition(this.x, this.y);
	this.add(equipped);

	equippedItem = entity.getComponent("item");
	equippedItem.call("onEquipped", [this]);
}

function unequip()
{
	if (equipped == null)
		return;
	this.remove(equipped);
	state.addEntity(equipped);
	equipped.visible = true;

	equippedItem.call("onUnequipped");
	equippedItem = null;
	equipped = null;

	hands.loadFromID(handsSpriteID);
	hands.angle = 0.0;
}

// Attempts to use the equipped item
function attemptUse(elapsed:Float)
{
	if (!equippedItem.call("getCanUse")) // Return if can't be used
		return;
	equippedItem.call("onUse", [elapsed, currentRiposteTime > 0.0]);
	if (currentRiposteTime > 0.0)
	{
		currentRiposteTime = 0.0;
		riposteParticle.animation.play("use", true);
		riposteParticle.visible = true;
		riposteUseSound.play();
	}
}

function getHands():AssetSprite
{
	return hands;
}

// Enables the frames where a riposte can be triggered
function triggerRiposte()
{
	currentRiposteTime = riposteDuration;
	riposteParticle.animation.play("trigger", true);
	riposteParticle.visible = true;
	riposteTriggerSound.play();
}

function onOverlap(tag:String, entity:Entity)
{
	if (tag != "damager"
		|| !health.call("getInvulnerable")
		|| currentRiposteTime > 0.0
		|| entity.getComponent("damager").get("team") == team)
		return;
	triggerRiposte(); // Trigger a riposte when invulnerable and touching a damager
}
