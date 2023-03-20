// Requires variables projectileID:String
function onUsed(equipper:Entity)
{
	equipper.getComponent("shooter").call("fire", [
		projectileID,
		FlxAngle.angleBetweenPoint(this, FlxG.mouse.getPosition(), true),
		1.0
	]);
}
