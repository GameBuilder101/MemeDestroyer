// Requires variables projectileID:String
function onUsed(equipper:Entity, riposte:Bool)
{
	equipper.getComponent("shooter").call("fire", [
		projectileID,
		FlxAngle.angleBetweenPoint(equipper, FlxG.mouse.getPosition(), true),
		riposte
	]);
}
