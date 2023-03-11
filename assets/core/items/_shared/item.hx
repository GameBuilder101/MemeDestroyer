// Requires variables altEquipSoundID:String, heldSpriteID:String, heldSpriteMode:String, useDelay:Float, useSoundID:String
var equipSound:AssetSound;
var altEquipSound:AssetSound;

// How much time is left until the item can be used again
var currentUseDelay:Float = 0.0;
var useSound:AssetSound;

function onLoaded()
{
	equipSound = AssetSoundRegistry.getAsset("items/_shared/sounds/equip");
	if (altEquipSoundID != null)
		altEquipSound = AssetSoundRegistry.getAsset(altEquipSoundID);

	if (useSoundID != null)
		useSound = AssetSoundRegistry.getAsset(useSoundID);
}

function onUpdate(elapsed:Float)
{
	currentUseDelay -= elapsed;
	if (currentUseDelay < 0.0)
		currentUseDelay = 0.0;
}

function onInteracted(entity:Entity)
{
	entity.components.callAll("equip", [this]);
	equipSound.play();
	if (altEquipSound != null)
		altEquipSound.play();
}

function getCanUse(entity:Entity):Bool
{
	return currentUseDelay <= 0.0;
}

function onUse(elapsed:Float, entity:Entity)
{
	currentUseDelay = useDelay;
	if (useSound != null)
		useSound.play();
}
