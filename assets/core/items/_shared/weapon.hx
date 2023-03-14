// Requires variables projectileID:String
// The component equipping this item
var equipper:GameScript;

function onEquipped(component:GameScript)
{
	equipper = component;
}

function onUse(elapsed:Float)
{
	equipper.get("this").getComponent("shooter").fire(projectileID);
}
