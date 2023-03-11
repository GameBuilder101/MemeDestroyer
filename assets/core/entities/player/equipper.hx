// The default hands sprite
var hands:AssetSprite;
var handsMode:String;

// The currently-equipped item entity
var equipped:Entity;

// The currently-equipped item component
var equippedItem:GameScript;

function onLoaded()
{
	hands = new AssetSprite(this.x, this.y, null, "entities/player/sprites/hands");
	this.add(hands);
}

function onUpdate(elapsed:Float)
{
	// Hands animation modes/angles
	switch (handsMode)
	{
		default:
		case "idle":
			hands.angle = 0.0;
		case "rotating":
			hands.angle = FlxAngle.angleBetweenPoint(this, FlxG.mouse.getPosition(), true);
			if (this.flipX)
				hands.angle -= 180.0;
	}

	// Use input
	if (equippedItem != null && Controls.checkFire())
		attemptUse(elapsed);

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

	equippedItem = equipped.components.getComponent("item");
	// Load the hands sprite
	hands.loadFromID(equippedItem.get("heldSpriteID"));
	handsMode = equippedItem.get("heldSpriteMode");
}

function unequip()
{
	if (equipped == null)
		return;
	this.remove(equipped);
	state.addEntity(equipped);
	equipped.visible = true;
	equipped = null;
	equippedItem = null;

	hands.loadFromID(handsSpriteID);
	handsMode = null;
}

// Attempts to use the equipped item
function attemptUse(elapsed:Float)
{
	if (!equippedItem.call("getCanUse", [this])) // Return if can't be used
		return;
	equippedItem.call("onUse", [elapsed, this]);
	if (hands.animation.exists("use"))
		hands.animation.play("use", true);
}
