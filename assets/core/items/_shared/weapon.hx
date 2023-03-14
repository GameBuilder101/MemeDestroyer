// Requires variables projectileID:String
// The component equipping this item
var equipper:GameScript;

function onEquipped(component:GameScript)
{
	equipper = component;
}

function onUse(elapsed:Float)
{
	trace(equipper);
	trace(equipper.get("this"));
	equipper.get("this").callAll("fire", [projectileID]);
}
