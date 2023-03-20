// Requires variables handsSpriteID:String

var equipped:Entity;

// The currently-equipped item component
var equippedItem:GameScript;

// The default hands sprite
var hands:AssetSprite;

function onLoaded()
{
	hands = new AssetSprite(this.x, this.y, null, "entities/player/sprites/hands");
	this.add(hands);
}

function onUpdate(elapsed:Float)
{
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

	if (hands.animation.finished && hands.animation.exists("idle"))
		hands.animation.play("idle");
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
	equippedItem.call("onUse", [elapsed]);
}

function getHands():AssetSprite
{
	return hands;
}
