// Component caches
var movement:GameScript;
var baseAI:GameScript;

function onLoaded()
{
	movement = getComponent("movement");
	baseAI = getComponent("base_ai");
}

function onUpdate(elapsed:Float)
{
	movement.call("move", [baseAI.call("getFacingVector"), false, elapsed]);
}
