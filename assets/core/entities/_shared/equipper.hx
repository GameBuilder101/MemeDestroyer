// Requires variables handsSpriteID:String
// The default hands sprite
var hands:AssetSprite;

// The currently-equipped item
var equipped:Entity;

function onLoaded()
{
	hands = new AssetSprite(this.x, this.y, null, handsSpriteID);
	this.add(hands);
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
}

function unequip()
{
	if (equipped == null)
		return;
	this.remove(equipped);
	state.addEntity(equipped);
	equipped.visible = true;
	equipped = null;
}
