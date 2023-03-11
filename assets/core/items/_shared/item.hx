// Requires variables altEquipSoundID:String, heldSpriteID:String, heldSpriteMode:String, useDelay:Float, useSoundID:String
// The component equipping this item
var equipper:GameScript;
var equipperHands:AssetSprite;

// The always-played equip sound
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
	entity.callAll("equip", [this]);
}

function onEquipped(component:GameScript)
{
	if (equipper != null)
		return;
	equipper = component;
	equipperHands = equipper.call("getHands");
	equipperHands.loadFromID(heldSpriteID);

	equipSound.play();
	if (altEquipSound != null)
		altEquipSound.play();
}

function onUnequipped()
{
	if (equipper == null)
		return;
	equipper = null;
	equipperHands = null;

	currentUseDelay = 0.0;
}

function getCanUse():Bool
{
	return currentUseDelay <= 0.0;
}

function onUse(elapsed:Float)
{
	currentUseDelay = useDelay;

	if (equipperHands.animation.exists("use"))
		equipperHands.animation.play("use", true);
	if (useSound != null)
		useSound.play();
}
