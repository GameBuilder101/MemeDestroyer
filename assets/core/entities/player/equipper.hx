// The currently-equipped item entity
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
		// Hands sprite animation modes/angles
		switch (equippedItem.get("heldSpriteMode"))
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

	equippedItem = equipped.getComponent("item");
	equipped.callAll("onEquipped", [getComponent("equipper")]);
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
	equippedItem = null;

	hands.loadFromID(handsSpriteID);
	hands.angle = 0.0;
}

// Attempts to use the equipped item
function attemptUse(elapsed:Float)
{
	if (!equippedItem.call("getCanUse")) // Return if can't be used
		return;
	equipped.callAll("onUse", [elapsed]);
}

function getHands():AssetSprite
{
	return hands;
}
