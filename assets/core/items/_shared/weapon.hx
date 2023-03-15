// Requires variables projectileID:String
var equipper:Entity;

function onEquipped(entity:Entity)
{
	equipper = entity;
}

function onUse(elapsed:Float)
{
	equipper.callAll("fire", [projectileID, equipper.callAll("getLookAngle"), 1.0]);
}
