package ui;

import entity.Entity;
import entity.EntityRegistry;
import flixel.group.FlxSpriteGroup;
import gbc.graphics.AssetSprite;

class Inventory extends FlxSpriteGroup
{
	var slots:Array<FlxSpriteGroup> = [];

	/** Used to make sure a slot doesn't get re-loaded with the same item sprite. **/
	var slotSpriteIDs:Array<String> = [];

	var selectedSlot:Int = -1;

	public function new(x:Float = 0.0, y:Float = 0.0)
	{
		super(x, y);
		scrollFactor.set(0.0, 0.0);
	}

	public function addSlot()
	{
		var slot:FlxSpriteGroup = new FlxSpriteGroup();
		var x:Float = slots.length * 48.0;
		slot.add(new AssetSprite(x, 0.0, null, "ui/_shared/sprites/inventory_slot"));
		slot.add(new AssetSprite(x, -4.0));
		add(slot);
		slots.push(slot);
		slotSpriteIDs.push(null);
	}

	public function removeSlot()
	{
		remove(slots[slots.length - 1], true);
		slots.pop();
		slotSpriteIDs.pop();
	}

	/** Sets the item sprite in a slot. **/
	public function setItemInSlot(index:Int, item:Entity)
	{
		var itemSprite:AssetSprite = cast(slots[index].members[1], AssetSprite);
		if (item == null)
		{
			itemSprite.visible = false;
			slotSpriteIDs[index] = null;
			return;
		}

		var spriteID:String = EntityRegistry.getAsset(item.id).spriteID;
		if (slotSpriteIDs[index] == spriteID)
			return;
		itemSprite.loadFromID(spriteID);
		slotSpriteIDs[index] = spriteID;

		itemSprite.x = slots[index].members[0].x + (slots[index].members[0].width - itemSprite.width) * 0.5;
		itemSprite.visible = true;
	}

	public function setSelectedSlot(index:Int)
	{
		if (selectedSlot >= 0)
			slots[selectedSlot].members[0].animation.play("idle"); // Reset the previously-selected slot
		selectedSlot = index;
		slots[selectedSlot].members[0].animation.play("selected");
	}
}
