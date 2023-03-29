// Component caches
var movement:GameScript;
var baseAI:GameScript;

function onLoaded()
{
	movement = getComponent("movement");
	baseAI = getComponent("base_ai");

	baseAI.call("setTarget", [state.player]);
}

function onUpdate(elapsed:Float)
{
	if (baseAI.call("getTarget") == null)
		return;
	movement.call("move", [baseAI.call("getFacingVector"), false, elapsed]);
}
