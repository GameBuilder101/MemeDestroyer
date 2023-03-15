// The currently-equipped item entity
var equipped:Entity;

// The default hands sprite
var hands:AssetSprite;

function onLoaded()
{
	hands = new AssetSprite(this.x, this.y, null, "entities/player/sprites/hands");
	this.add(hands);
}

function onUpdate(elapsed:Float)
{
	if (equipped != null)
	{
		/* Hands sprite animation modes/angles must be done here so that flipping is
			detected properly */
		switch (equipped.callAll("getHeldSpriteMode"))
		{
			default:
				hands.angle = 0.0;
			case "rotating":
				hands.angle = this.callAll("getLookAngle");
				if (this.flipX)
					hands.angle -= 180.0;
		}

		// Use input
		if (Controls.checkFire())
			attemptUse(elapsed);
	}

	if (hands.animation.name != "idle" && hands.animation.finished && hands.animation.exists("idle"))
		hands.animation.play("idle", true);
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

	equipped.callAll("onEquipped", [this]);
}

function unequip()
{
	if (equipped == null)
		return;
	this.remove(equipped);
	state.addEntity(equipped);
	equipped.visible = true;

	equipped.callAll("onUnequipped");

	equipped = null;

	hands.loadFromID(handsSpriteID);
	hands.angle = 0.0;
}

// Attempts to use the equipped item
function attemptUse(elapsed:Float)
{
	if (!equipped.callAll("getCanUse")) // Return if can't be used
		return;
	equipped.callAll("onUse", [elapsed]);
}

function getHands():AssetSprite
{
	return hands;
}
